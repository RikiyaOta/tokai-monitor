defmodule TokaiMonitorBackend.VideoStatisticCollector.Service.VideoService do
  use Timex
  alias TokaiMonitorBackend.TokaiMonitorDB.Repository.VideoRepository

  def upsert_videos(repo, channel_id, videos) do
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

    VideoRepository.insert_all(repo, entries, options)
  end
end
