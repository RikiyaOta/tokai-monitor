defmodule TokaiMonitorAPI.Helper.ConditionHelper do
  def if_not_nil(nil, _f), do: nil
  def if_not_nil(value, f), do: f.(value)

  def is_error(:ok), do: false
  def is_error({:ok, _}), do: false
  def is_error(:error), do: true
  def is_error({:error, _}), do: true
end
