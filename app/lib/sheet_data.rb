class SheetData
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
end
