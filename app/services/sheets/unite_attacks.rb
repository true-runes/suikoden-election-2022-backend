module Sheets
  class UniteAttacks
    def self.all_importer
      # 性質上、全削除してから全部入れ直す（主キーがない…）
      OnRawSheetUniteAttack.destroy_all

      # TODO: 設定ファイル的なものから持ってきたい
      sheet_names = [
        "幻水I",
        "幻水II",
        "幻水III",
        "幻水IV",
        "Rhapsodia",
        "幻水V",
        "TK",
        "紡時",
      ]

      sheet_names.each do |sheet_name|
        import_to_database(sheet_name: sheet_name)
      end
    end

    def self.get(sheet_name: nil)
      return 'シート名が指定されていません。' if sheet_name.nil?

      SheetData.get_rows(
        sheet_id: ENV.fetch('UNITE_ATTACKS_SHEET_ID'),
        range: "#{sheet_name}!A1:O"
      )
    end

    def self.import_to_database(sheet_name: nil)
      return 'シート名が指定されていません。' if sheet_name.nil?

      rows = SheetData.get_rows(
        sheet_id: ENV.fetch('UNITE_ATTACKS_SHEET_ID'),
        range: "#{sheet_name}!A1:O"
      )

      # TODO: ここは切り出しできそう
      # シート と DBカラム の対応表を自作しておく
      sheet_headers_and_column_names = YAML.load_file(
        Rails.root.join("config/sheet_headers_and_column_names_relations/on_raw_sheet_unite_attacks.yml")
      )
      cloumn_names_and_sheet_index_number = {}

      # TODO: ここは切り出しできそう
      # 実際のシートのヘッダーを取得し、自作の対応表からインデックス番号を算出する
      source_sheet_headers = rows[0]
      source_sheet_headers.each_with_index do |header, i|
        sheet_headers_and_column_names.find { |e| e['sheet_header'] == header }.tap do |e|
          next if e.nil?

          cloumn_names_and_sheet_index_number[e['column_name']] = i
        end
      end

      # TODO: バルクインサートする
      ActiveRecord::Base.transaction do
        rows.each_with_index do |row, i|
          # row[0] は id が入っている列
          next if i == 0 || row[cloumn_names_and_sheet_index_number['name']].blank? || row[0].blank?

          next if OnRawSheetUniteAttack.where(
            sheet_name: sheet_name,
            name: row[cloumn_names_and_sheet_index_number['name']]
          ).present?

          obj = OnRawSheetUniteAttack.new(
            sheet_name: sheet_name,
            name: row[cloumn_names_and_sheet_index_number['name']],
            kana: row[cloumn_names_and_sheet_index_number['kana']],
            name_en: row[cloumn_names_and_sheet_index_number['name_en']],
            chara_1: row[cloumn_names_and_sheet_index_number['chara_1']],
            chara_2: row[cloumn_names_and_sheet_index_number['chara_2']],
            chara_3: row[cloumn_names_and_sheet_index_number['chara_3']],
            chara_4: row[cloumn_names_and_sheet_index_number['chara_4']],
            chara_5: row[cloumn_names_and_sheet_index_number['chara_5']],
            chara_6: row[cloumn_names_and_sheet_index_number['chara_6']],
            page_annotation: row[cloumn_names_and_sheet_index_number['page_annotation']],
            memo: row[cloumn_names_and_sheet_index_number['memo']]
          )

          obj.save!
        end
      end
    end
  end
end
