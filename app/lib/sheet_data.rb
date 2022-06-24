class SheetData
  VALUE_INPUT_OPTION = 'USER_ENTERED'.freeze

  def self.get_rows(sheet_id:, range:)
    service = SheetService.new.service
    response = service.get_spreadsheet_values(sheet_id, range)

    return [] if response.values.empty?

    response.values
  end

  def self.get_rows_target_range(sheet_id:, range:)
    service = SheetService.new.service
    response = service.get_spreadsheet_values(sheet_id, range)

    response.range
  end

  def self.write_rows(sheet_id:, range:, values:)
    service = SheetService.new.service

    # 戻り値に updated_cells, updated_columns, updated_range, updated_rows メソッドが生えてる
    # range は A1 形式しか選択できない (https://googleapis.dev/ruby/google-api-client/latest/Google/Apis/SheetsV4/SheetsService.html#update_spreadsheet_value-instance_method)
    service.update_spreadsheet_value(
      sheet_id,
      range, # 貼り付け開始フォーカス位置
      Google::Apis::SheetsV4::ValueRange.new(values: values), # values は行列を示す二次元配列になることに注意する
      value_input_option: VALUE_INPUT_OPTION
    )
  end
end
