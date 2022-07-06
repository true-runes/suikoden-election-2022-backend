module Counting
  module Checkers
    class DirectMessages
      def initialize
        @sheet_names = sheet_names
      end

      # シートに直接アクセスしてチェックするため、そこそこ時間がかかる
      def not_good_rows_if_same_vote_contents_exist
        not_good_rows = []

        @sheet_names.each do |sheet_name|
          rows = rows(sheet_name) # ここでシートへのアクセスが発生する

          rows.each do |row|
            next if skip_this_row?(row)

            dm_column_vs_value = dm_column_vs_value(row)
            input_contents = [
              dm_column_vs_value[:input_01],
              dm_column_vs_value[:input_02],
              dm_column_vs_value[:input_03],
              dm_column_vs_value[:input_04],
              dm_column_vs_value[:input_05],
              dm_column_vs_value[:input_06],
              dm_column_vs_value[:input_07],
              dm_column_vs_value[:input_08],
              dm_column_vs_value[:input_09],
              dm_column_vs_value[:input_10],
            ].compact_blank

            next if input_contents.blank?

            not_good_rows << row if input_contents.size != input_contents.uniq.size
          end
        end

        not_good_rows
      end

      private

      def skip_this_row?(row)
        dm_column_vs_value = dm_column_vs_value(row)

        dm_column_vs_value[:id_on_sheet].blank? ||
          dm_column_vs_value[:dm_id_number].blank? ||
          dm_column_vs_value[:screen_name].blank? ||
          dm_column_vs_value[:contents].blank?
      end

      def rows(sheet_name)
        SheetData.get_rows(sheet_id: ENV.fetch('COUNTING_DIRECT_MESSAGES_SHEET_ID', nil), range: "#{sheet_name}!A2:Q101")
      end

      def sheet_names
        YAML.load_file(Rails.root.join('config/counting_sheet_names.yml'))['names']
      end

      def dm_column_vs_value(row)
        {
          id_on_sheet: row[0],
          screen_name: row[1],
          dm_id_number: row[2],
          is_invisible: row[5], # "FALSE" のような文字列なので注意
          is_out_of_counting: row[6], # "FALSE" のような文字列なので注意
          category: row[9],
          contents: row[10],
          memo: row[11],
          input_01: row[13],
          input_02: row[14],
          input_03: row[15],
          input_04: row[16],
          input_05: row[17],
          input_06: row[18],
          input_07: row[19],
          input_08: row[20],
          input_09: row[21],
          input_10: row[22]
        }
      end
    end
  end
end
