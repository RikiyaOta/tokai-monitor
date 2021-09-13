defmodule TokaiMonitorBackend.TokaiMonitorDBTest do
  use ExUnit.Case
  doctest TokaiMonitorBackend.TokaiMonitorDB

  test "greets the world" do
    assert TokaiMonitorBackend.TokaiMonitorDB.hello() == :world
  end
end
