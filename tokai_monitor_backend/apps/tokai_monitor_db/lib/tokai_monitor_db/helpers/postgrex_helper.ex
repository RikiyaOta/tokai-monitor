defmodule TokaiMonitorBackend.TokaiMonitorDB.Helper.PostgrexHelper do
  def to_maps(%Postgrex.Result{columns: columns, rows: rows}) do
    Enum.map(rows, fn row ->
      Enum.reduce(Enum.zip(columns, row), %{}, fn {k, v}, acc -> Map.put(acc, k, v) end)
    end)
  end
end
