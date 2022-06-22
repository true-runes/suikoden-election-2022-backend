class ChangeUniqueToOnRawSheetResultIllustrationTotallings < ActiveRecord::Migration[7.0]
  def up
    # ユニーク制約を除外するため、インデックスを外してから付け直す
    remove_index :on_raw_sheet_result_illustration_totallings, :character_name_for_public
    add_index :on_raw_sheet_result_illustration_totallings, :character_name_for_public, name: 'c_name_for_public_index'
  end

  def down
    # ユニーク制約を付与するため、インデックスを外してから付け直す
    remove_index :on_raw_sheet_result_illustration_totallings, :character_name_for_public
    add_index :on_raw_sheet_result_illustration_totallings, :character_name_for_public, unique: true, name: 'c_name_for_public_index'
  end
end
