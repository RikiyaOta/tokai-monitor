defmodule TokaiMonitorBackend.TokaiMonitorDB.Repo.Migrations.CreateIndexOnLikeCount do
  use Ecto.Migration

  def up do
    execute("""
    CREATE INDEX idx_like_count ON public.video_statistics USING btree (like_count);
    """)
  end

  def down do
    execute("""
    DROP INDEX idx_like_count;
    """)
  end
end
