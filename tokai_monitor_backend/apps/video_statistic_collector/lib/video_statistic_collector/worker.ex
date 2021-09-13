defmodule TokaiMonitorBackend.VideoStatisticCollector.Worker do
  @moduledoc """
  Main module for collecting TokaiOnair Video Statistics.
  """
  require Logger
  import TokaiMonitorBackend.TokaiMonitorCommon.Helper.ConditionHelper, only: [is_error: 1]
  alias TokaiMonitorBackend.TokaiMonitorDB.Repo
  alias TokaiMonitorBackend.TokaiMonitorDB.Repository.ChannelRepository
  alias TokaiMonitorBackend.TokaiMonitorCommon.Helper.MapHelper
  alias TokaiMonitorBackend.TokaiMonitorDB.Schema.Channel
  alias TokaiMonitorBackend.VideoStatisticCollector.Service.{VideoService, VideoStatisticService}

  @api_key Application.get_env(:tokai_monitor_api, :google_api_key)
  @base_url "https://www.googleapis.com/youtube/v3/"
  @base_query_params %{key: @api_key}

  def call(repo \\ Repo, http_client \\ HTTPoison) do
    Logger.info("Started VideoStatisticCollector.call/0 !!!")

    result =
      ChannelRepository.all(repo)
      |> Enum.map(&do_call_for(&1, repo, http_client))
      |> Enum.filter(&is_error/1)

    Logger.info("Finished VideoStatisticCollector.call/0 !!! result=#{inspect(result)}.")

    result
  end

  @spec do_call_for(Channel.t(), module(), module()) :: :ok | {:error, term()}
  defp do_call_for(%Channel{} = channel, repo, http_client) do
    with {:ok, playlist_id} <- fetch_uploaded_video_list_for(channel, http_client),
         {:ok, video_ids} <- fetch_video_ids_by_playlist_id(playlist_id, http_client),
         {:ok, videos} <- fetch_videos(video_ids, http_client) do
      repo.transaction(fn ->
        {_n, upserted_videos} = VideoService.upsert_videos(repo, channel.id, videos)
        {_n, _} = VideoStatisticService.switch_is_latest_to_false(repo, channel.id)
        {_n, _} = VideoStatisticService.insert_video_statistics(repo, upserted_videos, videos)
      end)
      |> case do
        {:ok, _} -> :ok
        {:error, error} -> {:error, error}
      end
    else
      {:error, error} -> {:error, error}
    end
  end

  @spec fetch_uploaded_video_list_for(Channel.t(), module()) ::
          {:ok, String.t()} | {:error, term()}
  defp fetch_uploaded_video_list_for(%Channel{} = channel, http_client) do
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

  @spec fetch_video_ids_by_playlist_id(String.t(), module(), list(), String.t() | nil) ::
          {:ok, [String.t()]} | {:error, term()}
  defp fetch_video_ids_by_playlist_id(
         playlist_id,
         http_client,
         result \\ [],
         next_page_token \\ nil
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

            fetch_video_ids_by_playlist_id(
              playlist_id,
              http_client,
              new_result,
              new_next_page_token
            )

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

  defp fetch_videos(video_ids, http_client, result \\ [])

  defp fetch_videos([], _http_client, result) do
    {:ok, result}
  end

  defp fetch_videos(video_ids, http_client, result) do
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
            fetch_videos(next_search_video_ids, http_client, new_result)

          {:error, error} ->
            {:error, error}
        end

      {:ok, %HTTPoison.Response{} = response} ->
        {:error, response}

      {:error, error} ->
        {:error, error}
    end
  end
end
