class CreateOnRawSheetResultIllustrationTotallings < ActiveRecord::Migration[6.1]
  def change
    create_table :on_raw_sheet_result_illustration_totallings do |t|
      t.string :character_name_by_sheet_totalling
      t.integer :number_of_applications
      t.string :character_name_for_public

      t.timestamps
    end

    add_index :on_raw_sheet_result_illustration_totallings, :character_name_by_sheet_totalling, unique: true, name: 'c_name_by_sheet_totalling_index'
    add_index :on_raw_sheet_result_illustration_totallings, :character_name_for_public, unique: true, name: 'c_name_for_public_index'
  end
end
