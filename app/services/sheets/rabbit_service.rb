# rubocop:disable Rails/Output, Style/HashEachMethods
module Sheets
  class RabbitService
    def self.quickstart
      service = SheetService.new.service

      # https://developers.google.com/sheets/api/quickstart/ruby
      # Prints the names and majors of students in a sample spreadsheet:
      # https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
      spreadsheet_id = "1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms"
      range = "Class Data!A2:E"
      response = service.get_spreadsheet_values spreadsheet_id, range
      puts "Name, Major:"
      puts "No data found." if response.values.empty?

      # ここの values メソッドは、ハッシュに対する values メソッドのことではない
      # response.class #=> Google::Apis::SheetsV4::ValueRange
      response.values.each do |row|
        # Print columns A and E, which correspond to indices 0 and 4.
        puts "#{row[0]}, #{row[4]}"
      end
    end
  end
end
# rubocop:enable Rails/Output, Style/HashEachMethods
