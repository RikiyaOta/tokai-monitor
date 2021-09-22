defmodule TokaiMonitorBackend.TokaiMonitorDB.Repo.Migrations.CreateIndexOnCommentCount do
  use Ecto.Migration

  def up do
    execute("""
    CREATE INDEX idx_comment_count ON public.video_statistics USING btree (comment_count);
    """)
  end

  def down do
    execute("""
    DROP INDEX idx_comment_count;
    """)
  end
end
