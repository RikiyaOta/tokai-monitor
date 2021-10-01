defmodule TokaiMonitorBackend.VideoStatisticCollector.Service.VideoStatisticService do
  import Ecto.Query, only: [from: 2]
  import TokaiMonitorBackend.TokaiMonitorCommon.Helper.ConditionHelper, only: [if_not_nil: 2]
  alias TokaiMonitorBackend.TokaiMonitorDB.Schema.{Video, VideoStatistic}

  def switch_is_latest_to_false(repo, channel_id) do
    now = DateTime.utc_now()

    query =
      from(video_statistic in VideoStatistic,
        inner_join: video in assoc(video_statistic, :video),
        where: video.channel_id == ^channel_id,
        where: video_statistic.is_latest == true
      )

    repo.update_all(query, set: [is_latest: false, updated_at: now])
  end

  def insert_video_statistics(repo, upserted_videos, video_params) do
    now = DateTime.utc_now()

    video_index =
      Enum.reduce(upserted_videos, %{}, fn %Video{id: id, video_id: video_id}, acc ->
        Map.put(acc, video_id, id)
      end)

    entries =
      Enum.map(video_params, fn video ->
        %{}
        |> Map.put(:video_id, Map.get(video_index, Map.get(video, "id")))
        |> Map.put(
          :view_count,
          video |> get_in(["statistics", "viewCount"]) |> if_not_nil(&String.to_integer/1)
        )
        |> Map.put(
          :like_count,
          video |> get_in(["statistics", "likeCount"]) |> if_not_nil(&String.to_integer/1)
        )
        |> Map.put(
          :dislike_count,
          video |> get_in(["statistics", "dislikeCount"]) |> if_not_nil(&String.to_integer/1)
        )
        |> Map.put(
          :comment_count,
          video |> get_in(["statistics", "commentCount"]) |> if_not_nil(&String.to_integer/1)
        )
        |> Map.put(:is_latest, true)
        |> Map.put(:created_at, now)
        |> Map.put(:updated_at, now)
      end)

    repo.insert_all(VideoStatistic, entries)
  end

  def upsert_latest_video_statistics(repo, channel_id) do
    raw_query = """
    INSERT INTO public.latest_video_statistics (
      video_id,
      view_count,
      like_count,
      dislike_count,
      comment_count,
      view_count_last_day,
      view_count_last_week,
      view_count_last_month,
      view_count_last_year,
      created_at
    )
    SELECT video_with_statistic.video_id
         , video_with_statistic.view_count
         , video_with_statistic.like_count
         , video_with_statistic.dislike_count
         , video_with_statistic.comment_count
         , video_with_statistic.view_count_last_day
         , video_with_statistic.view_count_last_week
         , video_with_statistic.view_count_last_month
         , video_with_statistic.view_count_last_year
         , NOW()
      FROM (
        SELECT v.id AS video_id
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
             , (
                 -- 再生数は減らないという前提
                 SELECT MAX(vs3.view_count) - MIN(vs3.view_count)
                   FROM public.video_statistics vs3
                  WHERE vs3.video_id = v.id
                    AND vs3.created_at >= (NOW() - '1 week'::interval)::timestamp with time zone
                    AND vs3.created_at <= NOW()
               ) AS view_count_last_week
             , (
                 -- 再生数は減らないという前提
                 SELECT MAX(vs4.view_count) - MIN(vs4.view_count)
                   FROM public.video_statistics vs4
                  WHERE vs4.video_id = v.id
                    AND vs4.created_at >= (NOW() - '1 month'::interval)::timestamp with time zone
                    AND vs4.created_at <= NOW()
               ) AS view_count_last_month
             , (
                 -- 再生数は減らないという前提
                 SELECT MAX(vs5.view_count) - MIN(vs5.view_count)
                   FROM public.video_statistics vs5
                  WHERE vs5.video_id = v.id
                    AND vs5.created_at >= (NOW() - '1 year'::interval)::timestamp with time zone
                    AND vs5.created_at <= NOW()
               ) AS view_count_last_year
        FROM public.videos v
        INNER JOIN public.video_statistics vs ON v.id = vs.video_id
        WHERE v.channel_id = $1::uuid
          AND vs.is_latest IS TRUE
      ) video_with_statistic
    ON CONFLICT ON CONSTRAINT pk_latest_video_statistics
    DO UPDATE SET view_count            = EXCLUDED.view_count
                , like_count            = EXCLUDED.like_count
                , dislike_count         = EXCLUDED.dislike_count
                , comment_count         = EXCLUDED.comment_count
                , view_count_last_day   = EXCLUDED.view_count_last_day
                , view_count_last_week  = EXCLUDED.view_count_last_week
                , view_count_last_month = EXCLUDED.view_count_last_month
                , view_count_last_year  = EXCLUDED.view_count_last_year
                , created_at            = EXCLUDED.created_at
    ;
    """

    repo.query(raw_query, [Ecto.UUID.dump!(channel_id)])
  end
end
