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
end
