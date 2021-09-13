defmodule TokaiMonitorBackend.TokaiMonitorCommonTest do
  use ExUnit.Case
  doctest TokaiMonitorBackend.TokaiMonitorCommon

  test "greets the world" do
    assert TokaiMonitorBackend.TokaiMonitorCommon.hello() == :world
  end
end
