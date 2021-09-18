defmodule TokaiMonitorBackend.TokaiMonitorDB.Repo.Migrations.AddColumnToChannelsIndexAndThumbnailUrlSetThumbnailUrl do
  use Ecto.Migration

  def up do
    execute("""
    ALTER TABLE public.channels
    ADD COLUMN index_number smallint,
    ADD COLUMN thumbnail_url text,
    ADD CONSTRAINT uq_index_number UNIQUE (index_number)
    ;
    """)

    execute("""
    -- 東海オンエア
    UPDATE public.channels
    SET index_number = 1,
        thumbnail_url = 'https://yt3.ggpht.com/ytc/AKedOLTDLauymQQXmfG3S_r3ZTzw8ds1VstwhcwvHU_8OA=s800-c-k-c0x00ffffff-no-rj'
    WHERE id = 'a6e3ba83-7c24-458f-a99b-5c0bbecb9da1'
    ;
    """)

    execute("""
    -- 東海オンエアの控え室
    UPDATE public.channels
    SET index_number = 2,
        thumbnail_url = 'https://yt3.ggpht.com/ytc/AKedOLQ29IomoYshW1g285mPxgIBpppmhMdqHcUfIO7k6w=s800-c-k-c0x00ffffff-no-rj'
    WHERE id = '6e4dba88-d188-4fe5-9f7b-7b51a1249d25'
    ;
    """)

    execute("""
    -- 動画アップロードチャンネル
    UPDATE public.channels
    SET index_number = 3,
        thumbnail_url = 'https://yt3.ggpht.com/zg_QfI1n_TTVEqmHOLzlMxj1JFfnLT2UvIm5SJmAQeY3QoBqTe-GohsYSQawWMjnEONMO2bAXiY=s800-c-k-c0x00ffffff-no-rj'
    WHERE id = 'e1f9f097-3e55-447e-a3df-4dfc4796a0d9'
    ;
    """)

    execute("""
    -- ニンマリシティへようこそ
    UPDATE public.channels
    SET index_number = 4,
        thumbnail_url = 'https://yt3.ggpht.com/ytc/AKedOLRLA77crQlB0pecSfbEOCFVJZGBjBgUHsaTTgEl=s800-c-k-c0x00ffffff-no-rj'
    WHERE id = '6c13d4fc-87a5-4095-9ccb-127383208935'
    ;
    """)

    execute("""
    -- ブラーボりょうのボンサバドゥ!チャンネル
    UPDATE public.channels
    SET index_number = 5,
        thumbnail_url = 'https://yt3.ggpht.com/h15Tw1BPxaqIkuJVX38m4nN4Ens2l7CrXEk9-8SjZAD2zuMCAh37-Aj0nTa2yZ0yyagopyE8=s800-c-k-c0x00ffffff-no-rj'
    WHERE id = 'f5c5bc67-84ee-4172-a230-3f32ef1278a5'
    ;
    """)

    execute("""
    -- としみつ東海オンエアの
    UPDATE public.channels
    SET index_number = 6,
        thumbnail_url = 'https://yt3.ggpht.com/NwZWESrzm5xavJJ9JH1VuWA2tsLhevBF8RRnebIibonRJx1Ium2hdr_lOizSqXlYl5gLs8v_=s800-c-k-c0x00ffffff-no-rj'
    WHERE id = 'd588c3c1-fc83-4a73-ac4f-952f2b4d1844'
    ;
    """)

    execute("""
    -- ゆめまる美術館
    UPDATE public.channels
    SET index_number = 7,
        thumbnail_url = 'https://yt3.ggpht.com/SqSGRYPs3xgn-7m2SAbQNc35K2XR9soou8-YHzy6QT2yBhv53VkmDfMxSyXV0GZl_UgofNDoJfw=s800-c-k-c0x00ffffff-no-rj'
    WHERE id = '6af859ef-f10d-476f-a637-d92a86badb20'
    ;
    """)

    execute("""
    -- 虫眼鏡の放送部
    UPDATE public.channels
    SET index_number = 8,
        thumbnail_url = 'https://yt3.ggpht.com/ytc/AKedOLTQHosh5YrLiQPLhTcnzLtGRvFuhXAndOLrArxQ=s800-c-k-c0x00ffffff-no-rj'
    WHERE id = 'e212644b-0ed0-4cc2-8aeb-1931aaf0e39a'
    ;
    """)

    execute("""
    ALTER TABLE public.channels
    ALTER COLUMN index_number SET NOT NULL,
    ALTER COLUMN thumbnail_url SET NOT NULL
    ;
    """)
  end

  def down do
    execute("""
    ALTER TABLE public.channels
    DROP COLUMN index_number CASCADE,
    DROP COLUMN thumbnail_url CASCADE
    ;
    """)
  end
end
