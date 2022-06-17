module Sheets
  class UniteAttacks
    def self.run
      rows = SheetData.get_rows(
        sheet_id: ENV.fetch('UNITE_ATTACKS_SHEET_ID'),
        range: "幻水II!A2:H"
      )

      pp rows
    end
  end
end
