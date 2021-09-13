defmodule TokaiMonitorBackend.VideoStatisticCollector.Service.VideoStatisticService do
  import Ecto.Query, only: [from: 2]
  import TokaiMonitorBackend.TokaiMonitorCommon.Helper.ConditionHelper, only: [if_not_nil: 2]
  alias TokaiMonitorBackend.TokaiMonitorDB.Schema.{Video, VideoStatistic}

  def switch_is_latest_to_false(repo, channel_id) do
    now = DateTime.utc_now()

    query =
      from(video_statistic in VideoStatistic,
        inner_join: video in assoc(video_statistic, :video),
        where: video.channel_id == ^channel_id,
        where: video_statistic.is_latest == true
      )

    repo.update_all(query, set: [is_latest: false, updated_at: now])
  end

  def insert_video_statistics(repo, upserted_videos, video_params) do
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
