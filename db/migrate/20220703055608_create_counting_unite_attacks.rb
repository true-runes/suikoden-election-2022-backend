class CreateCountingUniteAttacks < ActiveRecord::Migration[7.0]
  def change
    create_table :counting_unite_attacks do |t|
      t.integer :id_on_sheet # tweet の id と dm の id とで重複があり得る
      t.integer :user_id, null: false
      t.integer :vote_method, null: false
      t.integer :tweet_id # dm の場合は NULL があり得る
      t.integer :direct_message_id
      t.string :other_tweet_ids_text # "|" で区切った文字列
      t.boolean :is_invisible
      t.boolean :is_out_of_counting
      t.string :contents
      t.string :memo
      t.string :product_name
      t.string :unite_attack_name

      t.timestamps
    end
  end
end
