module Sheets
  module WriteAndUpdate
    module FinalSummary
      class ShortStories
        def initialize
          @sheet_name = 'まとめ'
          @column_name_to_index_hash = {
            id: 0,
            id_on_sheet: 1,
            投稿方法: 2,
            URL: 3,
            「お題」: 4,
            内容: 5,
            開票後の紹介可: 6, # 手動入力
            キャラ名: 7
          }
        end

        def exec
          base_records = CountingBonusVote.ranking_short_stories
          rows = []

          base_records.each_with_index do |record, index|
            row = []

            row[@column_name_to_index_hash[:id]] = index + 1
            row[@column_name_to_index_hash[:id_on_sheet]] = record[:id_on_sheet]
            row[@column_name_to_index_hash[:投稿方法]] = record[:vote_method]
            row[@column_name_to_index_hash[:URL]] = record[:url]
            row[@column_name_to_index_hash[:「お題」]] = record[:theme]
            row[@column_name_to_index_hash[:内容]] = record[:contents]
            row[@column_name_to_index_hash[:キャラ名]] = record[:character_name]

            rows << row
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
            sheet_id: ENV.fetch('FINAL_SUMMARY_SHORT_STORIES_SHEET_ID', nil),
            range: "#{@sheet_name}!A2", # 始点
            values: written_data
          )
        end

        def delete
          SheetData.write_rows(
            sheet_id: ENV.fetch('FINAL_SUMMARY_SHORT_STORIES_SHEET_ID', nil),
            range: "#{@sheet_name}!A2:H501",
            values: [
              ['', '', '', '', '', '', nil, ''],
            ] * 500
          )
        end
      end
    end
  end
end
