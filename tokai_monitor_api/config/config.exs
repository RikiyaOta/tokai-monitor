# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tokai_monitor_api,
  namespace: TokaiMonitorAPI,
  ecto_repos: [TokaiMonitorAPI.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :tokai_monitor_api, TokaiMonitorAPIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VzfT05/QxLEkwJwLkrMbkUj9DVUYMjSsFCu/JQ/veI7NADUVAzjte04GGZ55EnKO",
  render_errors: [view: TokaiMonitorAPIWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TokaiMonitorAPI.PubSub,
  live_view: [signing_salt: "6awh/Y6B"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
