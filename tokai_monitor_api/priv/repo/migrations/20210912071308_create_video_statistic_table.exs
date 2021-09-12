defmodule TokaiMonitorAPI.Repo.Migrations.CreateVideoStatisticTable do
  use Ecto.Migration

  def up do
    execute("""
    CREATE TABLE public.video_statistics (
    id uuid NOT NULL,
    video_id uuid NOT NULL,
    view_count bigint,
    like_count bigint,
    dislike_count bigint,
    comment_count bigint,
    created_at timestamp with time zone NOT NULL,

    CONSTRAINT pk_video_statistics PRIMARY KEY (id)
    );
    """)

    execute("""
    CREATE INDEX idx_video_id ON public.video_statistics USING btree (video_id);
    """)

    execute("""
    ALTER TABLE public.video_statistics ADD CONSTRAINT fk_videos FOREIGN KEY (video_id)
    REFERENCES public.videos (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;
    """)
  end

  def down do
    execute("DROP TABLE public.video_statistics CASCADE;")
  end
end
