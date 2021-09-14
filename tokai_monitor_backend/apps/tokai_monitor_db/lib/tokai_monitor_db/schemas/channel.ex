defmodule TokaiMonitorBackend.TokaiMonitorDB.Schema.Channel do
  use TokaiMonitorBackend.TokaiMonitorDB.Schema

  schema "channels" do
    field(:channel_id, :string)
    field(:title, :string)
    field(:created_at, :utc_datetime_usec)
    field(:updated_at, :utc_datetime_usec)
  end
end
