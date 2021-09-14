defmodule TokaiMonitorBackend.TokaiMonitorDB.Validator do
  def validate_positive(field, value) do
    if value > 0, do: [], else: [{field, "cannot be 0 or negative"}]
  end
end
