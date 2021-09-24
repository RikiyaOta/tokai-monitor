defmodule TokaiMonitorBackend.TokaiMonitorAPI.Service.VideoService do
  use Timex

  alias TokaiMonitorBackend.TokaiMonitorAPIWeb.Params.V1.{
    VideoRankingParams,
    VideoIncreaseRankingParams
  }

  alias TokaiMonitorBackend.TokaiMonitorDB.Repo
  alias TokaiMonitorBackend.TokaiMonitorDB.Helper.PostgrexHelper

  def get_videos_with_statistics(%VideoRankingParams{
        :"channel.id" => channel_id,
        :"page.page_number" => page_number,
        :"page.page_size" => page_size,
        :"page.sort_key" => sort_key,
        :"page.sort_type" => sort_type
      }) do
    offset = (page_number - 1) * page_size

    raw_query = """
    SELECT video_with_statistic.id
         , video_with_statistic.video_id
         , video_with_statistic.title
         , video_with_statistic.published_at
         , video_with_statistic.view_count
         , video_with_statistic.like_count
         , video_with_statistic.dislike_count
         , video_with_statistic.comment_count
         , video_with_statistic.view_count_last_day
      FROM (
        SELECT v.id
             , v.video_id
             , v.title
             , v.published_at
             , vs.view_count
             , vs.like_count
             , vs.dislike_count
             , vs.comment_count
             , (
                 -- 再生数は減らないという前提
                 SELECT MAX(vs2.view_count) - MIN(vs2.view_count)
                   FROM public.video_statistics vs2
                  WHERE vs2.video_id = v.id
                    AND vs2.created_at >= (NOW() - '1 day'::interval)::timestamp with time zone
                    AND vs2.created_at <= NOW()
               ) AS view_count_last_day
        FROM public.videos v
        INNER JOIN public.video_statistics vs ON v.id = vs.video_id
        WHERE v.channel_id = $1::uuid
          AND vs.is_latest IS TRUE
    ) video_with_statistic
    ORDER BY video_with_statistic.#{sort_key} #{sort_type} NULLS LAST
    OFFSET $2::integer
    LIMIT $3::integer
    ;
    """

    Repo.query(raw_query, [
      Ecto.UUID.dump!(channel_id),
      offset,
      page_size
    ])
    |> case do
      {:ok, result} ->
        {:ok, PostgrexHelper.to_maps(result)}

      {:error, error} ->
        {:error, error}
    end
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
      {:ok, result} ->
        {:ok, PostgrexHelper.to_maps(result)}

      {:error, error} ->
        {:error, error}
    end
  end
end
