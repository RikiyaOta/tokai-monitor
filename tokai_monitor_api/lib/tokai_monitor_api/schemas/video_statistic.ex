defmodule TokaiMonitorAPI.Schema.VideoStatistic do
  use TokaiMonitorAPI.Schema
  alias TokaiMonitorAPI.Schema.Video

  schema "video_statistics" do
    field :view_count, :integer
    field :like_count, :integer
    field :dislike_count, :integer
    field :comment_count, :integer
    field :is_latest, :boolean
    field :created_at, :utc_datetime_usec
    field :updated_at, :utc_datetime_usec

    belongs_to :video, Video
  end
end
