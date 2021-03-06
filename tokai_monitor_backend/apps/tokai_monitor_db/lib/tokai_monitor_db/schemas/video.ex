defmodule TokaiMonitorBackend.TokaiMonitorDB.Schema.Video do
  use TokaiMonitorBackend.TokaiMonitorDB.Schema
  alias TokaiMonitorBackend.TokaiMonitorDB.Schema.{Channel, VideoStatistic}

  schema "videos" do
    field(:video_id, :string)
    field(:title, :string)
    field(:published_at, :utc_datetime)
    field(:created_at, :utc_datetime_usec)
    field(:updated_at, :utc_datetime_usec)

    belongs_to(:channel, Channel)
    has_many(:video_statistics, VideoStatistic)
  end
end
