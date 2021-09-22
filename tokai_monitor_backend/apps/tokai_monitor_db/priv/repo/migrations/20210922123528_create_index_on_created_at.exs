defmodule TokaiMonitorBackend.TokaiMonitorDB.Repo.Migrations.CreateIndexOnCreatedAt do
  use Ecto.Migration

  def up do
    execute("""
    CREATE INDEX idx_created_at ON public.video_statistics USING btree (created_at);
    """)
  end

  def down do
    execute("""
    DROP INDEX idx_created_at;
    """)
  end
end
