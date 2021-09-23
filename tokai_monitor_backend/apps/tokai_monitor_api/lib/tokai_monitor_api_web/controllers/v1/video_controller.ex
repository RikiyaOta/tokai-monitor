defmodule TokaiMonitorBackend.TokaiMonitorAPIWeb.V1.VideoController do
  use TokaiMonitorBackend.TokaiMonitorAPIWeb, :controller
  require Logger

  alias TokaiMonitorBackend.TokaiMonitorAPIWeb.Params.V1.{
    VideoRankingParams,
    VideoIncreaseRankingParams
  }

  alias TokaiMonitorBackend.TokaiMonitorAPI.Service.VideoService

  def get_ranking(conn, params) do
    case VideoRankingParams.from(params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        changeset
        |> Params.data()
        |> VideoService.get_videos_with_statistics()
        |> case do
          {:ok, videos} ->
            render(conn, "video_ranking.json", videos: videos)

          {:error, error} ->
            Logger.error(
              "An error occurred in VideoController.get_ranking. error=#{inspect(error)}."
            )

            conn
            |> put_status(500)
            |> json(%{error: "internal_server_error"})
        end

      error ->
        Logger.info("Invalid request arrived. error=#{inspect(error)}.")

        conn
        |> put_status(400)
        |> json(%{error: "invalid_parameters"})
    end
  end

  def get_increase_ranking(conn, params) do
    case VideoIncreaseRankingParams.from(params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        changeset
        |> Params.data()
        |> VideoService.get_videos_with_increment()
        |> case do
          {:ok, videos} ->
            render(conn, "video_increment_ranking.json", videos: videos)

          {:error, error} ->
            Logger.error("Server error occurred. error=#{inspect(error)}.")

            conn
            |> put_status(500)
            |> json(%{error: "internal_server_error"})
        end

      error ->
        Logger.info("Invalid request arrived. error=#{inspect(error)}.")

        conn
        |> put_status(400)
        |> json(%{error: "invalid_parameters"})
    end
  end
end
