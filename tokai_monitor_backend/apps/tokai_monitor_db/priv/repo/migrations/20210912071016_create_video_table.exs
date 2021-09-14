defmodule TokaiMonitorAPI.Repo.Migrations.CreateVideoTable do
  use Ecto.Migration

  def up do
    execute("""
    CREATE TABLE public.videos (
      id uuid NOT NULL,
      channel_id uuid NOT NULL,
      video_id text NOT NULL,
      title text NOT NULL,
      published_at timestamp with time zone NOT NULL,
      created_at timestamp with time zone NOT NULL,
      updated_at timestamp with time zone NOT NULL,

      CONSTRAINT pk_videos PRIMARY KEY (id),
      CONSTRAINT uq_channle_id_video_id UNIQUE (channel_id,video_id)
    );
    """)

    execute("""
    ALTER TABLE public.videos ADD CONSTRAINT fk_channels FOREIGN KEY (channel_id)
    REFERENCES public.channels (id) MATCH FULL
    ON DELETE CASCADE ON UPDATE CASCADE;
    """)

    execute("""
    CREATE INDEX idx_channel_id ON public.videos USING btree (channel_id);
    """)
  end

  def down do
    execute("DROP TABLE public.videos CASCADE;")
  end
end
