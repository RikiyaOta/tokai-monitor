defmodule TokaiMonitorAPI.Repo.Migrations.AddUpdatedAtColumnToVideoStatistics do
  use Ecto.Migration

  def up do
    execute("""
    ALTER TABLE public.video_statistics ADD COLUMN updated_at timestamp with time zone;
    """)

    execute("""
    UPDATE public.video_statistics
    SET updated_at = created_at
    ;
    """)

    execute("""
    ALTER TABLE public.video_statistics ALTER COLUMN updated_at SET NOT NULL;
    """)
  end

  def down do
    execute("""
    ALTER TABLE public.video_statistics DROP COLUMN updated_at;
    """)
  end
end
