defmodule TokaiMonitorAPI.Repo.Migrations.AddTokaiHikaesitsu do
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
      '6e4dba88-d188-4fe5-9f7b-7b51a1249d25',
      'UCynIYcsBwTrwBIecconPN2A',
      '東海オンエアの控え室',
      NOW(),
      NOW()
    )
    ;
    """)
  end

  def down do
    execute("DELETE FROM public.channels WHERE id = '6e4dba88-d188-4fe5-9f7b-7b51a1249d25';")
  end
end
