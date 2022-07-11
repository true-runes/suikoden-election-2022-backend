module Sheets
  module WriteAndUpdate
    module FinalSummary
      class FavQuotes
        def initialize
          @sheet_name = 'まとめ'
          @column_name_to_index_hash = {
            id: 0,
            シートid: 1,
            投稿方法: 2,
            投稿内容: 3,
            キャラ名: 4,
            台詞のみ（カギカッコ不要）: 5, # シート側で入力
            備考: 6, # シート側で入力
            第一候補: 7, # シート側で入力
            第二候補: 8, # シート側で入力
            文字数: 9 # シート側で入力
          }
        end

        def exec
          base_records = CountingBonusVote.valid_records.where(bonus_category: :fav_quotes)
          chara_columns = %i[chara_01 chara_02 chara_03 chara_04 chara_05 chara_06 chara_07 chara_08 chara_09 chara_10]

          rows = []

          base_records.each_with_index do |record, index|
            character_names = chara_columns.map { |c| record[c] }.compact_blank.reject { |el| el == "FALSE"}

            # キャラが複数いる場合には分割する（一キャラ一台詞一レコード）
            character_names.each do |character_name|
              row = []

              id = index + 1
              sheet_id = record.id_on_sheet
              vote_method = record.vote_method
              contents = record.contents

              row[@column_name_to_index_hash[:id]] = id
              row[@column_name_to_index_hash[:シートid]] = sheet_id
              row[@column_name_to_index_hash[:投稿方法]] = vote_method
              row[@column_name_to_index_hash[:投稿内容]] = contents
              row[@column_name_to_index_hash[:キャラ名]] = character_name

              rows << row
            end
          end

          rows = rows.sort_by do |element_array|
            [
              element_array[@column_name_to_index_hash[:キャラ名]],
            ]
          end

          delete
          write(rows)
        end

        def write(written_data)
          SheetData.write_rows(
            sheet_id: ENV.fetch('FINAL_SUMMARY_FAV_QUOTES_SHEET_ID', nil),
            range: "#{@sheet_name}!A2", # 始点
            values: written_data
          )
        end

        def delete
          SheetData.write_rows(
            sheet_id: ENV.fetch('FINAL_SUMMARY_FAV_QUOTES_SHEET_ID', nil),
            range: "#{@sheet_name}!A2:E501",
            values: [[''] * 5] * 500 # A列からE列までの列 の 500行 を空文字で埋める
          )
        end
      end
    end
  end
end
