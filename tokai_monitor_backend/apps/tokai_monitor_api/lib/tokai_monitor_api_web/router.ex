defmodule TokaiMonitorBackend.TokaiMonitorAPIWeb.Router do
  use TokaiMonitorBackend.TokaiMonitorAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TokaiMonitorBackend.TokaiMonitorAPIWeb do
    pipe_through :api
  end
end
