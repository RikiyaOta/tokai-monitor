defmodule TokaiMonitorBackend.VideoStatisticCollector.MixProject do
  use Mix.Project

  def project do
    [
      app: :video_statistic_collector,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TokaiMonitorBackend.VideoStatisticCollector.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true}
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:quantum, "~> 3.0"},
      {:timex, "~> 3.0"},
      {:tokai_monitor_common, in_umbrella: true},
      {:tokai_monitor_db, in_umbrella: true}
    ]
  end
end
