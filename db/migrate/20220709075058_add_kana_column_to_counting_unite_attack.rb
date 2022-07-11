class AddKanaColumnToCountingUniteAttack < ActiveRecord::Migration[7.0]
  def change
    add_column :counting_unite_attacks, :kana, :string
  end
end
