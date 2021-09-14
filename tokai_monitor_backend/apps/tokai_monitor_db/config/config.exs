import Config

config :tokai_monitor_db, ecto_repos: [TokaiMonitorBackend.TokaiMonitorDB.Repo]

import_config "#{Mix.env()}.exs"
