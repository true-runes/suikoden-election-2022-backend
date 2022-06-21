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
            memo: row[cloumn_names_and_sheet_index_number['memo']],
          )

          obj.save!
        end
      end
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

      # シートから持ってきたレコードのうち、無効なレコードを除外する
      valid_rows = []
      rows.each_with_index do |row, i|
        next if i == 0 || row[cloumn_names_and_sheet_index_number['character_name_for_sheet_totalling']].blank? || row[cloumn_names_and_sheet_index_number['character_name_for_public']].blank?

        valid_rows << row
      end

      # 更新がなければメソッドを抜ける
      return 'Not Modified.' if valid_rows.count == OnRawSheetResultIllustrationTotalling.count

      ActiveRecord::Base.transaction do
        # 主キーがないから問答無用で全削除して入れ直す
        OnRawSheetResultIllustrationTotalling.destroy_all

        rows.each_with_index do |row, i|
          next if i == 0 || row[cloumn_names_and_sheet_index_number['character_name_for_sheet_totalling']].blank? || row[cloumn_names_and_sheet_index_number['character_name_for_public']].blank?

          obj = OnRawSheetResultIllustrationTotalling.new(
            character_name_by_sheet_totalling: row[cloumn_names_and_sheet_index_number['character_name_for_sheet_totalling']],
            number_of_applications: row[cloumn_names_and_sheet_index_number['number_of_applications']],
            character_name_for_public: row[cloumn_names_and_sheet_index_number['character_name_for_public']],
          )

          obj.save!
        end
      end
    end
  end
end
