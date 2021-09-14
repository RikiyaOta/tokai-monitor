defmodule TokaiMonitorAPI.Repo.Migrations.InsertTokaiOnairChannelInfo do
  use Ecto.Migration

  def up do
    execute("""
    INSERT INTO public.channels (
      id,
      channel_id,
      title,
      created_at,
      updated_at
    )
    VALUES
    (
      'a6e3ba83-7c24-458f-a99b-5c0bbecb9da1',
      'UCutJqz56653xV2wwSvut_hQ',
      '東海オンエア',
      NOW(),
      NOW()
    )
    ;
    """)
  end

  def down do
    execute("DELETE FROM public.channels WHERE id = 'a6e3ba83-7c24-458f-a99b-5c0bbecb9da1';")
  end
end
