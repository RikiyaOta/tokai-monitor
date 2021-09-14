defmodule TokaiMonitorAPI.Repo.Migrations.CreateChannelTable do
  use Ecto.Migration

  def up do
    execute("""
    CREATE TABLE public.channels (
      id uuid NOT NULL,
      channel_id text NOT NULL,
      title text NOT NULL,
      created_at timestamp with time zone NOT NULL,
      updated_at timestamp with time zone NOT NULL,

      CONSTRAINT pk_channels PRIMARY KEY (id),
      CONSTRAINT uq_channel_id UNIQUE (channel_id)
    );
    """)
  end

  def down do
    execute("DROP TABLE public.channels CASCADE;")
  end
end
