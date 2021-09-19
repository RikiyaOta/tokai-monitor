defmodule TokaiMonitorBackend.TokaiMonitorAPIWeb.V1.VideoView do
  use TokaiMonitorBackend.TokaiMonitorAPIWeb, :view

  def render("video_ranking.json", %{videos: videos}) do
    %{
      videos: render_many(videos, __MODULE__, "video.json")
    }
  end

  def render("video.json", %{video: video}) do
    [video_statistic] = video.video_statistics

    %{
      id: video.id,
      video_id: video.video_id,
      title: video.title,
      published_at: video.published_at,
      statistics: %{
        view_count: video_statistic.view_count,
        like_count: video_statistic.like_count,
        dislike_count: video_statistic.dislike_count,
        comment_count: video_statistic.comment_count
      }
    }
  end

  def render("video_increment_ranking.json", %{videos: videos}) do
    %{
      videos: render_many(videos, __MODULE__, "video_with_increment.json")
    }
  end

  def render("video_with_increment.json", %{video: video}) do
    %{
      id: Ecto.UUID.cast!(Map.get(video, "id")),
      video_id: Map.get(video, "video_id"),
      title: Map.get(video, "title"),
      published_at: Map.get(video, "published_at"),
      start_count: Map.get(video, "start_count"),
      end_count: Map.get(video, "end_count"),
      increment: Map.get(video, "increment")
    }
  end
end
