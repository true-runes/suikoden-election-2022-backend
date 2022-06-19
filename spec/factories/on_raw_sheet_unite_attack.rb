FactoryBot.define do
  factory :on_raw_sheet_unite_attack do
    sheet_name { '幻水II' }
    name { 'ダブルリーダー攻撃' }
    kana { 'だぶるりーだー' }
    name_en { 'Double Leader Attack' }
    chara_1 { '主人公' }
    chara_2 { '1主人公' }
    chara_3 { nil }
    chara_4 { nil }
    chara_5 { nil }
    chara_6 { nil }
    page_annotation { nil }
    memo { nil }
  end

  trait :s1 do
    sheet_name { '幻水I' }
  end

  trait :s3 do
    sheet_name { '幻水III' }
  end

  trait :s4 do
    sheet_name { '幻水IV' }
  end

  trait :tactics do
    sheet_name { 'Rhapsodia' }
  end

  trait :s5 do
    sheet_name { '幻水V' }
  end

  trait :tk do
    sheet_name { 'TK' }
  end

  trait :woven do
    sheet_name { '紡時' }
  end
end
