defmodule TokaiMonitorBackend.TokaiMonitorAPIWeb.Router do
  use TokaiMonitorBackend.TokaiMonitorAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1/", TokaiMonitorBackend.TokaiMonitorAPIWeb.V1 do
    pipe_through :api

    get("/videos/ranking", VideoController, :get_ranking)
  end
end
