defmodule TokaiMonitorBackend.TokaiMonitorDB.Repository.VideoRepository do
  alias TokaiMonitorBackend.TokaiMonitorDB.Schema.Video

  def insert_all(repo, entries, options) do
    repo.insert_all(Video, entries, options)
  end
end
