class CreateOnRawSheetUniteAttacks < ActiveRecord::Migration[6.1]
  def change
    # あくまでシートの生データなので、リレーションシップは考えず独立テーブルとする
    create_table :on_raw_sheet_unite_attacks do |t|
      t.string :sheet_name, null: false
      t.string :name, null: false
      t.string :kana
      t.string :name_en
      t.string :chara_1
      t.string :chara_2
      t.string :chara_3
      t.string :chara_4
      t.string :chara_5
      t.string :chara_6
      t.string :page_annotation
      t.string :memo

      t.timestamps
    end
  end
end
