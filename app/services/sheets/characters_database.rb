# character database
module Sheets
  class CharactersDatabase
    def self.run
      rows = SheetData.get_rows(
        sheet_id: ENV.fetch('CHARACTERS_DATABASE_SHEET_ID'),
        range: "登場作品一覧!A2:P"
      )

      pp rows
    end
  end
end
