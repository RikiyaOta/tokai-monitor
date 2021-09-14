defmodule TokaiMonitorBackend.TokaiMonitorCommon.Constant.Page do
  defmacro asc, do: "asc"
  defmacro desc, do: "desc"

  defmacro sort_types, do: [asc(), desc()]
end
