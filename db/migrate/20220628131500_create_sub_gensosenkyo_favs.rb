class CreateSubGensosenkyoFavs < ActiveRecord::Migration[7.0]
  def change
    create_table :sub_gensosenkyo_favs do |t|
      t.bigint :id_number, null: false
      t.references :tweet

      t.timestamps
    end
  end
end
