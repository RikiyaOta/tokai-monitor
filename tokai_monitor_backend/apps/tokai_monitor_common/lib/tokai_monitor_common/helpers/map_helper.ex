defmodule TokaiMonitorBackend.TokaiMonitorCommon.Helper.MapHelper do
  def delete_nil_keys(map) do
    Enum.reduce(map, %{}, fn
      {_key, nil}, acc -> acc
      {key, value}, acc -> Map.put(acc, key, value)
    end)
  end
end
