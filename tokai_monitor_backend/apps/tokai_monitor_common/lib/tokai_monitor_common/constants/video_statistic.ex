defmodule TokaiMonitorBackend.TokaiMonitorCommon.Constant.VideoStatistic do
  defmacro view_count, do: "view_count"
  defmacro like_count, do: "like_count"
  defmacro dislike_count, do: "dislike_count"
  defmacro comment_count, do: "comment_count"

  defmacro video_statitic_keys,
    do: [
      view_count(),
      like_count(),
      dislike_count(),
      comment_count()
    ]
end
