class CreateOnRawSheetResultIllustrationStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :on_raw_sheet_result_illustration_statuses do |t|
      t.integer :id_on_sheet, null: false
      t.string :character_name, null: false
      t.string :name, null: false
      t.string :screen_name, null: false
      t.string :join_sosenkyo_book
      t.string :memo

      t.timestamps
    end

    add_index :on_raw_sheet_result_illustration_statuses, :id_on_sheet, unique: true, name: 'id_on_sheet_index'
  end
end
