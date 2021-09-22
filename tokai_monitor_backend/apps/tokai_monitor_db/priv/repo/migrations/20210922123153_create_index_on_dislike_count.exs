defmodule TokaiMonitorBackend.TokaiMonitorDB.Repo.Migrations.CreateIndexOnDislikeCount do
  use Ecto.Migration

  def up do
    execute("""
    CREATE INDEX idx_dislike_count ON public.video_statistics USING btree (dislike_count);
    """)
  end

  def down do
    execute("""
    DROP INDEX idx_dislike_count;
    """)
  end
end
