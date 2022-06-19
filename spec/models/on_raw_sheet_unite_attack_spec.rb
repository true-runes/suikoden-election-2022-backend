require 'rails_helper'

RSpec.describe OnRawSheetUniteAttack, type: :model do
  let(:unite_attack) { build(:on_raw_sheet_unite_attack) }

  it '属性が期待どおりであること' do
    expect(unite_attack.sheet_name).to eq '幻水II'
    expect(unite_attack.name).to eq 'ダブルリーダー攻撃'
    expect(unite_attack.kana).to eq 'だぶるりーだー'
    expect(unite_attack.name_en).to eq 'Double Leader Attack'
    expect(unite_attack.chara_1).to eq '主人公'
    expect(unite_attack.chara_2).to eq '1主人公'
    expect(unite_attack.chara_3).to eq nil
  end
end
