module Sheets
  class ResultIllustrationApplications
    def self.get
      SheetData.get_rows(
        sheet_id: ENV.fetch('RESULTS_ILLUSTRATIONS_APPLICATION_STATUS_SHEET_ID'),
        range: "開票イラスト!A1:P"
      )
    end

    # 「生ログ」なので、急いで必要になることはない
    def self.import_statuses_data_to_database
      rows = SheetData.get_rows(
        sheet_id: ENV.fetch('RESULTS_ILLUSTRATIONS_APPLICATION_STATUS_SHEET_ID'),
        range: "開票イラスト!A1:P"
      )

      sheet_headers_and_column_names = YAML.load_file(
        Rails.root.join("config/sheet_headers_and_column_names_relations/on_raw_sheet_result_illustration_statuses.yml")
      )
      cloumn_names_and_sheet_index_number = {}

      # 実際のシートのヘッダーを取得し、自作の対応表からインデックス番号を算出する
      source_sheet_headers = rows[0]
      source_sheet_headers.each_with_index do |header, i|
        sheet_headers_and_column_names.find { |e| e['sheet_header'] == header }.tap do |e|
          next if e.nil?

          cloumn_names_and_sheet_index_number[e['column_name']] = i
        end
      end

      ActiveRecord::Base.transaction do
        rows.each_with_index do |row, i|
          next if i == 0 || row[cloumn_names_and_sheet_index_number['id_on_sheet']].blank? || row[cloumn_names_and_sheet_index_number['character_name']].blank?

          next if OnRawSheetResultIllustrationStatus.where(
            id_on_sheet: row[cloumn_names_and_sheet_index_number['id_on_sheet']]
          ).present?

          obj = OnRawSheetResultIllustrationStatus.new(
            id_on_sheet: row[cloumn_names_and_sheet_index_number['id_on_sheet']],
            character_name: row[cloumn_names_and_sheet_index_number['character_name']],
            name: row[cloumn_names_and_sheet_index_number['name']],
            screen_name: row[cloumn_names_and_sheet_index_number['screen_name']],
            join_sosenkyo_book: row[cloumn_names_and_sheet_index_number['join_sosenkyo_book']],
            memo: row[cloumn_names_and_sheet_index_number['memo']]
          )

          obj.save!
        end
      end

      '[DONE] Sheets::ResultIllustrationApplications.import_statuses_data_to_database'
    end

    # API のレスポンスの元となるデータ
    def self.import_totallings_data_to_database
      rows = SheetData.get_rows(
        sheet_id: ENV.fetch('RESULTS_ILLUSTRATIONS_APPLICATION_STATUS_SHEET_ID'),
        range: "開票イラスト!A1:P"
      )

      sheet_headers_and_column_names = YAML.load_file(
        Rails.root.join("config/sheet_headers_and_column_names_relations/on_raw_sheet_result_illustration_totallings.yml")
      )
      cloumn_names_and_sheet_index_number = {}
      source_sheet_headers = rows[0]

      # 実際のシートのヘッダーを取得し、自作の対応表からインデックス番号を算出する
      source_sheet_headers.each_with_index do |header, i|
        sheet_headers_and_column_names.find { |e| e['sheet_header'] == header }.tap do |e|
          next if e.nil?

          cloumn_names_and_sheet_index_number[e['column_name']] = i
        end
      end

      # シートから持ってきたレコードのうち、無効なレコードを除外する（TEMP_ は含まれていることに注意する）
      valid_character_name_for_public_rows = []
      rows.each_with_index do |row, i|
        next if i == 0 || row[cloumn_names_and_sheet_index_number['character_name_for_public']].blank?

        valid_character_name_for_public_rows << row
      end
      valid_character_name_by_sheet_totalling_rows = rows.map.with_index { |row, index| row[7] unless index.zero? }.compact_blank

      # 更新がなければメソッドを抜ける
      return '[NOT MODIFIED] Sheets::ResultIllustrationApplications.import_totallings_data_to_database' if not_modified?(
        valid_character_name_for_public_rows,
        valid_character_name_by_sheet_totalling_rows
      )

      ActiveRecord::Base.transaction do
        # 主キーがないから問答無用で全削除して入れ直す
        OnRawSheetResultIllustrationTotalling.destroy_all

        rows.each_with_index do |row, i|
          next if i == 0 ||
                  (row[cloumn_names_and_sheet_index_number['character_name_for_public']].blank? && row[cloumn_names_and_sheet_index_number['character_name_for_sheet_totalling']].blank?)

          # FIXME: ワークアラウンドなので要修正
          temporary_inserted_data_for_totalling = "TEMP_TOTALLING_#{SecureRandom.uuid}"
          temporary_inserted_data_for_public = "TEMP_PUBLIC_#{SecureRandom.uuid}"

          character_name_by_sheet_totalling_data = row[cloumn_names_and_sheet_index_number['character_name_for_sheet_totalling']].presence || temporary_inserted_data_for_totalling
          character_name_for_public = row[cloumn_names_and_sheet_index_number['character_name_for_public']].presence || temporary_inserted_data_for_public

          obj = OnRawSheetResultIllustrationTotalling.new(
            character_name_by_sheet_totalling: character_name_by_sheet_totalling_data,
            number_of_applications: row[cloumn_names_and_sheet_index_number['number_of_applications']],
            character_name_for_public: character_name_for_public
          )

          obj.save!
        end
      end

      '[DONE] Sheets::ResultIllustrationApplications.import_totallings_data_to_database'
    end

    def self.not_modified?(public_rows, sheet_totalling_rows)
      public_rows.count == without_temp_records(OnRawSheetResultIllustrationTotalling.pluck(:character_name_for_public)).count &&
        sheet_totalling_rows.count == without_temp_records(OnRawSheetResultIllustrationTotalling.pluck(:character_name_by_sheet_totalling)).count
    end

    def self.without_temp_records(source_records)
      source_records.reject { |cell| cell.start_with?('TEMP_') }
    end
  end
end
