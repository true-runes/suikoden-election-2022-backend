# Sheets::ResultsIllustrationsApplicationStatus.run
module Sheets
  class ResultsIllustrationsApplicationStatus
    def self.run
      rows = SheetData.rows(
        sheet_id: ENV.fetch('RESULTS_ILLUSTRATIONS_APPLICATION_STATUS_SHEET_ID'),
        range: "開票イラスト!H2:I"
      )

      # これは共通？もうちょっと広く、不要行メソッドを作るといいかも
      rows_without_unnecessary = rows.reject { |e| e == ["", "0"] }

      # これは個別
      character_names = rows_without_unnecessary.map { |i| i[0] } # i[1] は応募数

      character_names.count
    end
  end
end
