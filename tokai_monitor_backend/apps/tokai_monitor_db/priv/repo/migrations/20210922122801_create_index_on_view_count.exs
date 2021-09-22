defmodule TokaiMonitorBackend.TokaiMonitorDB.Repo.Migrations.CreateIndexOnViewCount do
  use Ecto.Migration

  def up do
    execute("""
    CREATE INDEX idx_view_count ON public.video_statistics USING btree (view_count);
    """)
  end

  def down do
    execute("""
    DROP INDEX idx_view_count;
    """)
  end
end
