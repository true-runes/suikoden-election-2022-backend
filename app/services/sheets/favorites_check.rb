module Sheets
  class FavoritesCheck
    def self.run
      rows = SheetData.get_rows(
        sheet_id: ENV.fetch('SUB_GENSOSENKYO_FAVORITES_CHECK_SHEET_ID'),
        range: "お題小説!A2:H"
      )

      Rails.logger.debug rows
    end
  end
end
