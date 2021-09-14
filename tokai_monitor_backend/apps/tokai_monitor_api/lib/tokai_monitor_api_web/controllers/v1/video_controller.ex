defmodule TokaiMonitorBackend.TokaiMonitorAPIWeb.V1.VideoController do
  use TokaiMonitorBackend.TokaiMonitorAPIWeb, :controller
  require Logger
  alias TokaiMonitorBackend.TokaiMonitorAPIWeb.Params.V1.VideoRankingParams
  alias TokaiMonitorBackend.TokaiMonitorAPI.Service.VideoService

  def get_ranking(conn, params) do
    IO.inspect(conn)
    IO.inspect(params)
    IO.inspect(VideoRankingParams.from(params))

    case VideoRankingParams.from(params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        videos =
          changeset
          |> Params.data()
          |> VideoService.get_videos_with_statistics()

        render(conn, "video_ranking.json", videos: videos)

      error ->
        Logger.info("Invalid request arrived. error=#{inspect(error)}.")

        conn
        |> put_status(400)
        |> json(%{error: "invalid_parameters"})
    end
  end
end
