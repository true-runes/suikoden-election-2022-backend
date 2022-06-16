class SheetData
  def self.rows(sheet_id:, range:)
    service = SheetService.new.service
    response = service.get_spreadsheet_values(sheet_id, range)

    return [] if response.values.empty?

    response.values
  end

  def self.target_range(sheet_id:, range:)
    service = SheetService.new.service
    response = service.get_spreadsheet_values(sheet_id, range)

    response.range
  end
end
