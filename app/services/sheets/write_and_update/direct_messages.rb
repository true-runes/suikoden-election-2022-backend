module Sheets
  module WriteAndUpdate
    class DirectMessages
      # データベースサーバが停止していたため、落ちていた際のレコードは別扱いにする
      def self.exec(complement_missing_messages: false)
        direct_messages = if complement_missing_messages
          DirectMessage.missing_records.for_spreadsheet
                          else
          DirectMessage.remove_missing_records.for_spreadsheet
                          end

        direct_messages.each_slice(100).with_index do |dm_100, index_on_hundred|
          prepared_written_data_by_array_in_hash = []

          dm_100.each do |dm|
            inserted_hash = {}

            inserted_hash['screen_name'] = dm.user.screen_name
            inserted_hash['dm_id'] = dm.id_number.to_s
            inserted_hash['日時'] = dm.messaged_at.strftime('%Y/%m/%d %H:%M:%S').to_s
            inserted_hash['内容'] = dm.content_text
            # この行のコストが高い
            inserted_hash['suggested_names'] = NaturalLanguage::SuggestCharacterNames.exec(dm) # Array

            prepared_written_data_by_array_in_hash << inserted_hash
          end

          two_digit_number = if complement_missing_messages
            # 取得漏れは '集計_15' から記録する
            format(
              '%02<number>d',
              number: (index_on_hundred + 14) + 1
            )
                             else
            format(
              '%02<number>d',
              number: index_on_hundred + 1
            )
                             end

          sheet_name = "集計_#{two_digit_number}"
          written_data = []

          prepared_written_data_by_array_in_hash.each_with_index do |written_data_hash, index|
            row = []

            # TODO: 取得漏れには 10001 始まりを付与したい
            id_on_sheet = if complement_missing_messages
              ((index_on_hundred + 14) * 100) + (index + 1)
                          else
              (index_on_hundred * 100) + (index + 1)
                          end

            # TODO: ハードコーディングをしたくない
            row[0] = id_on_sheet
            row[1] = written_data_hash['screen_name']
            row[2] = written_data_hash['dm_id']
            row[3] = written_data_hash['日時']
            row[10] = written_data_hash['内容']
            row[49] = written_data_hash['suggested_names'] # 50列目 (AX)
            row[199] = '' # 200列目 (GR) を表示させるために空文字を入れる

            row.flatten! # suggested_names は長さが不定なので flatten する

            written_data << row
          end

          # suggested_names を最初に全削除する
          SheetData.write_rows(
            sheet_id: ENV.fetch('COUNTING_DIRECT_MESSAGES_SHEET_ID', nil),
            range: "#{sheet_name}!AX2:GR101",
            values: [[''] * 50] * 100 # 100行分の空文字を入れる
          )

          SheetData.write_rows(
            sheet_id: ENV.fetch('COUNTING_DIRECT_MESSAGES_SHEET_ID', nil),
            range: "#{sheet_name}!A2", # 始点
            values: written_data
          )
        end
      end
    end
  end
end
