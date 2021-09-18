defmodule TokaiMonitorBackend.TokaiMonitorAPIWeb.V1.ChannelController do
  use TokaiMonitorBackend.TokaiMonitorAPIWeb, :controller
  alias TokaiMonitorBackend.TokaiMonitorDB.Repository.ChannelRepository

  def index(conn, _params) do
    channels = ChannelRepository.all()
    render(conn, "channels.json", channels: channels)
  end
end
