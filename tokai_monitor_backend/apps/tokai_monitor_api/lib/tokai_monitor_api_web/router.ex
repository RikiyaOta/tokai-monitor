defmodule TokaiMonitorBackend.TokaiMonitorAPIWeb.Router do
  use TokaiMonitorBackend.TokaiMonitorAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1/", TokaiMonitorBackend.TokaiMonitorAPIWeb.V1 do
    pipe_through :api

    get("/channels", ChannelController, :index)
    get("/videos/ranking", VideoController, :get_ranking)
    get("/videos/increase-ranking", VideoController, :get_increase_ranking)
  end
end
