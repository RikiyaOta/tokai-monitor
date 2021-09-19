defmodule TokaiMonitorBackend.TokaiMonitorAPI.Service.VideoService do
  use Timex
  import Ecto.Query

  import TokaiMonitorBackend.TokaiMonitorCommon.Constant.VideoStatistic,
    only: [view_count: 0, like_count: 0, dislike_count: 0, comment_count: 0]

  alias TokaiMonitorBackend.TokaiMonitorAPIWeb.Params.V1.{
    VideoRankingParams,
    VideoIncreaseRankingParams
  }

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

  def get_videos_with_increment(%VideoIncreaseRankingParams{} = params) do
    now = Timex.now()
    channel_id = Map.get(params, :"channel.id")
    period_unit = Map.get(params, :"period.unit")
    period_value = Map.get(params, :"period.value")
    key = Map.get(params, :key)
    sort_type = Map.get(params, :sort_type)
    page_number = Map.get(params, :"page.page_number")
    page_size = Map.get(params, :"page.page_size")

    start_time =
      case period_unit do
        "day" -> Timex.shift(now, days: period_value * -1)
        "week" -> Timex.shift(now, weeks: period_value * -1)
        "month" -> Timex.shift(now, months: period_value * -1)
        "year" -> Timex.shift(now, years: period_value * -1)
      end

    raw_query = """
    SELECT videos_with_increment.id
         , videos_with_increment.video_id
         , videos_with_increment.title
         , videos_with_increment.published_at
         , videos_with_increment.start_count
         , videos_with_increment.end_count
         , videos_with_increment.increment
    FROM (
      SELECT v.id
           , v.video_id
           , v.title
           , v.published_at
           , MIN(vs.#{key}) AS start_count
           , MAX(vs.#{key}) AS end_count
           , (MAX(vs.#{key}) - MIN(vs.#{key})) AS increment
      FROM public.videos v
      INNER JOIN public.video_statistics vs ON v.id = vs.video_id
      WHERE v.channel_id = $1::uuid
        AND vs.#{key} IS NOT NULL
        AND vs.created_at >= $2::timestamp with time zone
        AND vs.created_at <= $3::timestamp with time zone
      GROUP BY v.id
    ) videos_with_increment
    ORDER BY videos_with_increment.increment #{sort_type}
    OFFSET $4::integer
    LIMIT $5::integer
    ;
    """

    Repo.query(raw_query, [
      Ecto.UUID.dump!(channel_id),
      start_time,
      now,
      (page_number - 1) * page_size,
      page_size
    ])
    |> case do
      {:ok, %Postgrex.Result{columns: columns, rows: rows}} ->
        {:ok,
         Enum.map(rows, fn row ->
           Enum.reduce(Enum.zip(columns, row), %{}, fn {k, v}, acc -> Map.put(acc, k, v) end)
         end)}

      {:error, error} ->
        {:error, error}
    end
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
