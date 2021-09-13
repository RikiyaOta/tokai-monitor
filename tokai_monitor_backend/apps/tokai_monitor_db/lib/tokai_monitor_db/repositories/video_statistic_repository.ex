defmodule TokaiMonitorBackend.TokaiMonitorDB.Repository.VideoStatisticRepository do
  alias TokaiMonitorBackend.TokaiMonitorDB.Repo

  def update_all(repo \\ Repo, queryable, updates \\ [], options \\ []) do
    repo.update_all(queryable, updates, options)
  end
end
