defmodule TokaiMonitorBackend.TokaiMonitorDB.Repo do
  use Ecto.Repo,
    otp_app: :tokai_monitor_db,
    adapter: Ecto.Adapters.Postgres
end
