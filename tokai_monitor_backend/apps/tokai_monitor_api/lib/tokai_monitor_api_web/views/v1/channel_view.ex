defmodule TokaiMonitorBackend.TokaiMonitorAPIWeb.V1.ChannelView do
  use TokaiMonitorBackend.TokaiMonitorAPIWeb, :view

  def render("channels.json", %{channels: channels}) do
    %{
      channels: render_many(channels, __MODULE__, "channel.json")
    }
  end

  def render("channel.json", %{channel: channel}) do
    %{
      id: channel.id,
      channel_id: channel.channel_id,
      index_number: channel.index_number,
      title: channel.title,
      thumbnail_url: channel.thumbnail_url
    }
  end
end
