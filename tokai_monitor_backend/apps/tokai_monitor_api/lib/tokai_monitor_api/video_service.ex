defmodule TokaiMonitorBackend.TokaiMonitorAPI.Service.VideoService do
  import Ecto.Query

  import TokaiMonitorBackend.TokaiMonitorCommon.Constant.VideoStatistic,
    only: [view_count: 0, like_count: 0, dislike_count: 0, comment_count: 0]

  alias TokaiMonitorBackend.TokaiMonitorAPIWeb.Params.V1.VideoRankingParams
  alias TokaiMonitorBackend.TokaiMonitorDB.Schema.Video
  alias TokaiMonitorBackend.TokaiMonitorDB.Repo

  def get_videos_with_statistics(%VideoRankingParams{} = params) do
    query =
      Video
      |> filter_by(Map.get(params, :"channel.id"))
      |> preload_video_statistics()
      |> only_latest()
      |> where(^sort_key_is_not_nil(Map.get(params, :"page.sort_key")))
      |> order_by(^sort_by(Map.get(params, :"page.sort_key"), Map.get(params, :"page.sort_type")))
      |> offset(
        ^((Map.get(params, :"page.page_number") - 1) * Map.get(params, :"page.page_size"))
      )
      |> limit(^Map.get(params, :"page.page_size"))

    Repo.all(query)
  end

  defp filter_by(query, channel_id) do
    from(video in query,
      where: video.channel_id == ^channel_id
    )
  end

  defp preload_video_statistics(query) do
    from(video in query,
      inner_join: video_statistic in assoc(video, :video_statistics),
      as: :video_statistics,
      preload: [video_statistics: video_statistic]
    )
  end

  defp only_latest(query) do
    from([video_statistics: video_statistic] in query,
      where: video_statistic.is_latest
    )
  end

  defp sort_by(view_count(), sort_type),
    do: [
      {String.to_atom(sort_type),
       dynamic([video_statistics: video_statisc], video_statisc.view_count)}
    ]

  defp sort_by(like_count(), sort_type),
    do: [
      {String.to_atom(sort_type),
       dynamic([video_statistics: video_statisc], video_statisc.like_count)}
    ]

  defp sort_by(dislike_count(), sort_type),
    do: [
      {String.to_atom(sort_type),
       dynamic([video_statistics: video_statisc], video_statisc.dislike_count)}
    ]

  defp sort_by(comment_count(), sort_type),
    do: [
      {String.to_atom(sort_type),
       dynamic([video_statistics: video_statisc], video_statisc.comment_count)}
    ]

  defp sort_key_is_not_nil(view_count()),
    do: dynamic([video_statistics: video_statistic], not is_nil(video_statistic.view_count))

  defp sort_key_is_not_nil(like_count()),
    do: dynamic([video_statistics: video_statistic], not is_nil(video_statistic.like_count))

  defp sort_key_is_not_nil(dislike_count()),
    do: dynamic([video_statistics: video_statistic], not is_nil(video_statistic.dislike_count))

  defp sort_key_is_not_nil(comment_count()),
    do: dynamic([video_statistics: video_statistic], not is_nil(video_statistic.comment_count))
end
