defmodule TokaiMonitorBackend.TokaiMonitorCommon.Constant.Regex do
  def regex_uuid do
    ~r/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
  end
end
