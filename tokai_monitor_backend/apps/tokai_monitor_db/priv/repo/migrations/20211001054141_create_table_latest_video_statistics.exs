defmodule TokaiMonitorBackend.TokaiMonitorDB.Repo.Migrations.CreateTableLatestVideoStatistics do
  use Ecto.Migration

  def up do
    execute("""
    CREATE TABLE public.latest_video_statistics (
      video_id uuid NOT NULL,
      view_count bigint,
      like_count bigint,
      dislike_count bigint,
      comment_count bigint,
      view_count_last_day bigint,
      view_count_last_week bigint,
      view_count_last_month bigint,
      view_count_last_year bigint,
      created_at timestamp with time zone NOT NULL,

      CONSTRAINT pk_lastest_video_statistics PRIMARY KEY (video_id)
    );
    """)

    execute(
      "CREATE INDEX idx_latest_video_statistics_view_count ON public.latest_video_statistics USING btree ( view_count);"
    )

    execute(
      "CREATE INDEX idx_latest_video_statistics_like_count ON public.latest_video_statistics USING btree ( like_count);"
    )

    execute(
      "CREATE INDEX idx_latest_video_statistics_dislike_count ON public.latest_video_statistics USING btree ( dislike_count);"
    )

    execute(
      "CREATE INDEX idx_latest_video_statistics_comment_count ON public.latest_video_statistics USING btree ( comment_count);"
    )

    execute(
      "CREATE INDEX idx_latest_video_statistics_view_count_last_day ON public.latest_video_statistics USING btree ( view_count_last_day);"
    )

    execute(
      "CREATE INDEX idx_latest_video_statistics_view_count_last_week ON public.latest_video_statistics USING btree ( view_count_last_week);"
    )

    execute(
      "CREATE INDEX idx_latest_video_statistics_view_count_last_month ON public.latest_video_statistics USING btree ( view_count_last_month);"
    )

    execute(
      "CREATE INDEX idx_latest_video_statistics_view_count_last_year ON public.latest_video_statistics USING btree ( view_count_last_year);"
    )

    execute("""
    ALTER TABLE public.latest_video_statistics ADD CONSTRAINT fk_videos FOREIGN KEY (video_id)
    REFERENCES public.videos (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;
    """)
  end

  def down do
    execute("DROP TABLE public.latest_video_statistics CASCADE;")
  end
end
