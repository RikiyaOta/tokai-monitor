defmodule TokaiMonitorBackend.TokaiMonitorDB.Repository.ChannelRepository do
  alias TokaiMonitorBackend.TokaiMonitorDB.Repo
  alias TokaiMonitorBackend.TokaiMonitorDB.Schema.Channel

  def all(repo \\ Repo) do
    repo.all(Channel)
  end
end
