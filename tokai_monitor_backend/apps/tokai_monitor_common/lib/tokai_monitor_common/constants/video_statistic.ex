defmodule TokaiMonitorBackend.TokaiMonitorCommon.Constant.VideoStatistic do
  defmacro view_count, do: "view_count"
  defmacro like_count, do: "like_count"
  defmacro dislike_count, do: "dislike_count"
  defmacro comment_count, do: "comment_count"
  defmacro view_count_last_day, do: "view_count_last_day"
  defmacro view_count_last_week, do: "view_count_last_week"

  defmacro video_statitic_keys,
    do: [
      view_count(),
      like_count(),
      dislike_count(),
      comment_count(),
      view_count_last_day(),
      view_count_last_week()
    ]
end
