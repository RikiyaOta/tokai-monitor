defmodule TokaiMonitorBackend.TokaiMonitorDB.Schema.Channel do
  use TokaiMonitorBackend.TokaiMonitorDB.Schema

  schema "channels" do
    field(:channel_id, :string)
    field(:index_number, :integer)
    field(:title, :string)
    field(:thumbnail_url, :string)
    field(:created_at, :utc_datetime_usec)
    field(:updated_at, :utc_datetime_usec)
  end
end
