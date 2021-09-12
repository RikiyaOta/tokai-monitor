defmodule TokaiMonitorAPI.VideoStatisticCollector do
  @moduledoc """
  Main module for collecting TokaiOnair Video Statistics.
  """
  use Timex
  require Logger
  import Ecto.Query, only: [from: 2]
  import TokaiMonitorAPI.Helper.ConditionHelper, only: [if_not_nil: 2, is_error: 1]
  alias TokaiMonitorAPI.Repo
  alias TokaiMonitorAPI.Schema.{Channel, Video, VideoStatistic}
  alias TokaiMonitorAPI.Helper.MapHelper

  @api_key Application.get_env(:tokai_monitor_api, :google_api_key)
  @base_url "https://www.googleapis.com/youtube/v3/"
  @base_query_params %{key: @api_key}

  def call() do
    Logger.info("Started VideoStatisticCollector.call/0 !!!")

    result =
      get_channels()
      |> Enum.map(&do_call_for/1)
      |> Enum.filter(&is_error/1)

    Logger.info("Finished VideoStatisticCollector.call/0 !!! result=#{inspect(result)}.")

    result
  end

  @spec do_call_for(Channel.t(), module()) :: :ok | {:error, term()}
  defp do_call_for(%Channel{} = channel, repo \\ Repo) do
    with {:ok, playlist_id} <- fetch_uploaded_video_list_for(channel),
         {:ok, video_ids} <- fetch_video_ids_by_playlist_id(playlist_id),
         {:ok, videos} <- fetch_videos(video_ids) do
      repo.transaction(fn ->
        {_n, upserted_videos} = save_videos(channel.id, videos, repo)
        {_n, _} = switch_is_latest_to_false(channel.id, repo)
        {_n, _} = save_video_statistics(upserted_videos, videos, repo)
      end)
      |> case do
        {:ok, _} -> :ok
        {:error, error} -> {:error, error}
      end
    else
      {:error, error} -> {:error, error}
    end
  end

  defp get_channels(repo \\ Repo) do
    repo.all(Channel)
  end

  @spec fetch_uploaded_video_list_for(Channel.t(), module()) ::
          {:ok, String.t()} | {:error, term()}
  defp fetch_uploaded_video_list_for(%Channel{} = channel, http_client \\ HTTPoison) do
    url = Path.join(@base_url, "channels")

    query_params =
      @base_query_params
      |> Map.put(:part, "contentDetails")
      |> Map.put(:id, channel.channel_id)
      |> URI.encode_query()

    full_url = url <> "?" <> query_params

    case http_client.get(full_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok,
           %{
             "items" => [
               %{"contentDetails" => %{"relatedPlaylists" => %{"uploads" => uploaded_list_id}}}
             ]
           }} ->
            {:ok, uploaded_list_id}

          {:ok, _map} ->
            {:error, :uploaded_list_id_not_found}

          {:error, error} ->
            {:error, error}
        end

      {:ok, %HTTPoison.Response{} = response} ->
        {:error, response}

      {:error, error} ->
        {:error, error}
    end
  end

  @spec fetch_video_ids_by_playlist_id(String.t(), list(), String.t() | nil, module()) ::
          {:ok, [String.t()]} | {:error, term()}
  defp fetch_video_ids_by_playlist_id(
         playlist_id,
         result \\ [],
         next_page_token \\ nil,
         http_client \\ HTTPoison
       ) do
    url = Path.join(@base_url, "playlistItems")

    query_params =
      @base_query_params
      |> Map.put(:part, "contentDetails")
      |> Map.put(:playlistId, playlist_id)
      |> Map.put(:maxResults, 50)
      |> Map.put(:pageToken, next_page_token)
      |> MapHelper.delete_nil_keys()
      |> URI.encode_query()

    full_url = url <> "?" <> query_params

    case http_client.get(full_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"items" => items, "nextPageToken" => new_next_page_token}} ->
            new_result = Enum.map(items, &get_in(&1, ["contentDetails", "videoId"])) ++ result
            Process.sleep(1_000)
            fetch_video_ids_by_playlist_id(playlist_id, new_result, new_next_page_token)

          {:ok, %{"items" => items}} ->
            new_result = Enum.map(items, &get_in(&1, ["contentDetails", "videoId"])) ++ result
            {:ok, new_result}

          {:error, error} ->
            {:error, error}
        end

      {:ok, %HTTPoison.Response{} = response} ->
        {:error, response}

      {:error, error} ->
        {:error, error}
    end
  end

  defp fetch_videos(video_ids, result \\ [], http_client \\ HTTPoison)

  defp fetch_videos([], result, _http_client) do
    {:ok, result}
  end

  defp fetch_videos(video_ids, result, http_client) do
    url = Path.join(@base_url, "videos")
    {search_video_ids, next_search_video_ids} = Enum.split(video_ids, 50)

    query_params =
      @base_query_params
      |> Map.put(:part, "statistics,snippet")
      |> Map.put(:id, Enum.join(search_video_ids, ","))
      |> Map.put(:maxResults, 50)
      |> URI.encode_query()

    full_url = url <> "?" <> query_params

    case http_client.get(full_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"items" => items}} ->
            format_item = fn item ->
              item
              |> Map.take(["id", "statistics", "snippet"])
              |> update_in(["statistics"], &Map.delete(&1, "favoriteCount"))
              |> Map.put("title", get_in(item, ["snippet", "title"]))
              |> Map.put("published_at", get_in(item, ["snippet", "publishedAt"]))
              |> Map.delete("snippet")
            end

            new_result = Enum.map(items, format_item) ++ result
            Process.sleep(1_000)
            fetch_videos(next_search_video_ids, new_result)

          {:error, error} ->
            {:error, error}
        end

      {:ok, %HTTPoison.Response{} = response} ->
        {:error, response}

      {:error, error} ->
        {:error, error}
    end
  end

  @spec save_videos(String.t(), list(), module()) :: {integer(), [Video.t()]}
  defp save_videos(channel_id, videos, repo) do
    now = DateTime.utc_now()

    entries =
      Enum.map(videos, fn video ->
        %{}
        |> Map.put(:channel_id, channel_id)
        |> Map.put(:video_id, Map.get(video, "id"))
        |> Map.put(:title, Map.get(video, "title"))
        |> Map.put(
          :published_at,
          Map.get(video, "published_at") |> Timex.parse!("{ISO:Extended}")
        )
        |> Map.put(:created_at, now)
        |> Map.put(:updated_at, now)
      end)

    options = [
      returning: [:id, :video_id],
      on_conflict: {:replace, [:title, :updated_at]},
      conflict_target: [:channel_id, :video_id]
    ]

    repo.insert_all(Video, entries, options)
  end

  defp switch_is_latest_to_false(channel_id, repo) do
    now = DateTime.utc_now()

    query =
      from video_statistic in VideoStatistic,
        inner_join: video in assoc(video_statistic, :video),
        where: video.channel_id == ^channel_id,
        where: video_statistic.is_latest == true

    repo.update_all(query, set: [is_latest: false, updated_at: now])
  end

  defp save_video_statistics(upserted_videos, video_params, repo) do
    now = DateTime.utc_now()

    video_index =
      Enum.reduce(upserted_videos, %{}, fn %Video{id: id, video_id: video_id}, acc ->
        Map.put(acc, video_id, id)
      end)

    entries =
      Enum.map(video_params, fn video ->
        %{}
        |> Map.put(:video_id, Map.get(video_index, Map.get(video, "id")))
        |> Map.put(
          :view_count,
          video |> get_in(["statistics", "viewCount"]) |> if_not_nil(&String.to_integer/1)
        )
        |> Map.put(
          :like_count,
          video |> get_in(["statistics", "likeCount"]) |> if_not_nil(&String.to_integer/1)
        )
        |> Map.put(
          :dislike_count,
          video |> get_in(["statistics", "dislikeCount"]) |> if_not_nil(&String.to_integer/1)
        )
        |> Map.put(
          :comment_count,
          video |> get_in(["statistics", "commentCount"]) |> if_not_nil(&String.to_integer/1)
        )
        |> Map.put(:is_latest, true)
        |> Map.put(:created_at, now)
        |> Map.put(:updated_at, now)
      end)

    repo.insert_all(VideoStatistic, entries)
  end
end
