class AddCommentsToSomeColumns < ActiveRecord::Migration[7.0]
  # 空っぽの場合は nil を指定する
  def change
    # nicknames
    change_column_comment(:nicknames, :name, from: nil, to: '別名やプレイヤー間での呼称（日本語）')
    change_column_comment(:nicknames, :name_en, from: nil, to: '別名やプレイヤー間での呼称（英語）')

    # on_raw_sheet_result_illustration_totallings
    change_column_comment(
      :on_raw_sheet_result_illustration_totallings,
      :character_name_by_sheet_totalling,
      from: nil,
      to: '自動集計列のキャラ名'
    )
    change_column_comment(
      :on_raw_sheet_result_illustration_totallings,
      :number_of_applications,
      from: nil,
      to: '応募数'
    )
    change_column_comment(
      :on_raw_sheet_result_illustration_totallings,
      :character_name_for_public,
      from: nil,
      to: 'Webサイトに公開するキャラ名'
    )
  end
end
