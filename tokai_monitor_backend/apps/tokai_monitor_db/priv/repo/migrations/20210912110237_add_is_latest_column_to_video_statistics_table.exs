defmodule TokaiMonitorAPI.Repo.Migrations.AddIsLatestColumnToVideoStatisticsTable do
  use Ecto.Migration

  def up do
    execute("""
    ALTER TABLE public.video_statistics ADD COLUMN is_latest boolean;
    """)

    execute("""
    UPDATE public.video_statistics
    SET is_latest = FALSE
    ;
    """)

    execute("""
    UPDATE public.video_statistics
    SET is_latest = TRUE
    WHERE id IN (
      SELECT vs2.id
      FROM (
        SELECT vs.id
             , rank() OVER (PARTITION BY vs.video_id ORDER BY vs.created_at DESC) AS rank
        FROM public.video_statistics vs
      ) vs2
      WHERE vs2.rank = 1
    )
    ;
    """)

    execute("""
    ALTER TABLE public.video_statistics ALTER COLUMN is_latest SET NOT NULL;
    """)

    execute("""
    CREATE INDEX idx_is_latest ON public.video_statistics USING hash (is_latest);
    """)
  end

  def down do
    execute("""
    DROP INDEX idx_is_latest;
    """)

    execute("""
    ALTER TABLE public.video_statistics DROP COLUMN is_latest;
    """)
  end
end
