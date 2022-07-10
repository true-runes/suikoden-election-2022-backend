module Sheets
  module WriteAndUpdate
    module FinalSummary
      class ShortStories
        def initialize
          @sheet_name = 'まとめ'
          @column_name_to_index_hash = {
            id: 0,
            URL: 1,
            「お題」: 2,
            内容: 3,
            開票後の紹介可: 4,
            キャラ名: 5
          }
        end

        # o = Sheets::WriteAndUpdate::FinalSummary::ShortStories.new
        def exec
          base_records = CountingBonusVote.valid_records.where(bonus_category: :short_stories)
          rows = []

          base_records.each_with_index do |record, index|
            row = []

            id = index + 1

            # 取得漏れの場合は Tweet オブジェクトが存在しないのでシートの ID を入れておく（あまり良くない）
            url = if record.tweet.blank?
              record.id_on_sheet
                  else
              # 今回は DM でのお題小説の応募は無かったので Tweet だけ考慮すればいい
              record.tweet.url
                  end

            theme = record.short_stories_theme
            contents = record.contents

            chara_names = []
            chara_names << record.chara_01
            chara_names << record.chara_02
            chara_names << record.chara_03
            chara_names << record.chara_04
            chara_names << record.chara_05
            chara_names << record.chara_06
            chara_names << record.chara_07
            chara_names << record.chara_08
            chara_names << record.chara_09
            chara_names << record.chara_10
            chara_names = chara_names.compact_blank.sort.reject { |el| el == "FALSE"}

            row[@column_name_to_index_hash[:id]] = id
            row[@column_name_to_index_hash[:URL]] = url
            row[@column_name_to_index_hash[:「お題」]] = theme
            row[@column_name_to_index_hash[:内容]] = contents
            row[@column_name_to_index_hash[:キャラ名]] = chara_names.join

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
            range: "#{@sheet_name}!A2:E501",
            values: [[''] * 5] * 500 # A列からE列までの列 の 500行 を空文字で埋める
          )
        end
      end
    end
  end
end
