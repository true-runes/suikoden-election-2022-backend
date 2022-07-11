class AddCharaColumnsToCountingBonusVote < ActiveRecord::Migration[7.0]
  def change
    add_column :counting_bonus_votes, :chara_11, :string
    add_column :counting_bonus_votes, :chara_12, :string
  end
end
