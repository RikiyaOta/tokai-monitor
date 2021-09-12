defmodule TokaiMonitorAPI.Repo do
  use Ecto.Repo,
    otp_app: :tokai_monitor_api,
    adapter: Ecto.Adapters.Postgres
end
