class CreateCountingBonusVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :counting_bonus_votes do |t|
      t.integer :id_on_sheet # tweet の id と dm の id とで重複があり得る
      t.integer :user_id, null: false
      t.integer :bonus_category, null: false
      t.integer :vote_method, null: false
      t.integer :tweet_id # dm の場合は NULL があり得る
      t.integer :direct_message_id
      t.string :other_tweet_ids_text # "|" で区切った文字列
      t.boolean :is_invisible
      t.boolean :is_out_of_counting
      t.boolean :is_recovered
      t.string :contents
      t.string :memo
      t.string :chara_01
      t.string :chara_02
      t.string :chara_03
      t.string :chara_04
      t.string :chara_05
      t.string :chara_06
      t.string :chara_07
      t.string :chara_08
      t.string :chara_09
      t.string :chara_10

      t.timestamps
    end
  end
end
