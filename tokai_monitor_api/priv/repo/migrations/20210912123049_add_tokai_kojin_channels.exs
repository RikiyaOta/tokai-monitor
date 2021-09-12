defmodule TokaiMonitorAPI.Repo.Migrations.AddTokaiKojinChannels do
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
      'e1f9f097-3e55-447e-a3df-4dfc4796a0d9',
      'UC1xd0cAOryAMTTG34joEgdg',
      '動画アップロードチャンネル',
      NOW(),
      NOW()
    ),
    (
      'e212644b-0ed0-4cc2-8aeb-1931aaf0e39a',
      'UCbSIiNFWbJCW8ERBbkNMfwQ',
      '虫眼鏡の放送部',
      NOW(),
      NOW()
    ),
    (
      'd588c3c1-fc83-4a73-ac4f-952f2b4d1844',
      'UCDFxQgB9Dc_MzxiEKjozWwg',
      'としみつ東海オンエアの',
      NOW(),
      NOW()
    ),
    (
      'f5c5bc67-84ee-4172-a230-3f32ef1278a5',
      'UCigMkMDZjvLhXAQ67wKQIbA',
      'ブラーボりょうのボンサバドゥ!チャンネル',
      NOW(),
      NOW()
    ),
    (
      '6af859ef-f10d-476f-a637-d92a86badb20',
      'UCevQsKO8q1XQcEA1BoBO2gA',
      'ゆめまる美術館',
      NOW(),
      NOW()
    ),
    (
      '6c13d4fc-87a5-4095-9ccb-127383208935',
      'UCoj8N6ji1mpSYiZni69YojA',
      'ニンマリシティへようこそ',
      NOW(),
      NOW()
    )
    ;
    """)
  end

  def down do
    execute("DELETE FROM public.channels WHERE id = 'e1f9f097-3e55-447e-a3df-4dfc4796a0d9';")
    execute("DELETE FROM public.channels WHERE id = 'e212644b-0ed0-4cc2-8aeb-1931aaf0e39a';")
    execute("DELETE FROM public.channels WHERE id = 'd588c3c1-fc83-4a73-ac4f-952f2b4d1844';")
    execute("DELETE FROM public.channels WHERE id = 'f5c5bc67-84ee-4172-a230-3f32ef1278a5';")
    execute("DELETE FROM public.channels WHERE id = '6af859ef-f10d-476f-a637-d92a86badb20';")
    execute("DELETE FROM public.channels WHERE id = '6c13d4fc-87a5-4095-9ccb-127383208935';")
  end
end
