defmodule TokaiMonitorBackend.TokaiMonitorAPIWeb.V1.VideoView do
  use TokaiMonitorBackend.TokaiMonitorAPIWeb, :view

  def render("video_ranking.json", %{total_entries_count: total_entries_count, videos: videos}) do
    %{
      page: %{
        total_entries_count: total_entries_count
      },
      videos: render_many(videos, __MODULE__, "video.json")
    }
  end

  def render("video.json", %{video: video}) do
    %{
      id: Ecto.UUID.cast!(Map.get(video, "id")),
      video_id: Map.get(video, "video_id"),
      title: Map.get(video, "title"),
      published_at: Map.get(video, "published_at"),
      view_count: Map.get(video, "view_count"),
      like_count: Map.get(video, "like_count"),
      dislike_count: Map.get(video, "dislike_count"),
      comment_count: Map.get(video, "comment_count"),
      view_count_last_day: Map.get(video, "view_count_last_day"),
      view_count_last_week: Map.get(video, "view_count_last_week"),
      view_count_last_month: Map.get(video, "view_count_last_month"),
      view_count_last_year: Map.get(video, "view_count_last_year")
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
