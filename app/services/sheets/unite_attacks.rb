module Sheets
  class UniteAttacks
    # s1, s2, s3, s4, tactics, s5, tk, woven, card_stories, gaiden1, gaiden2
    def self.get(title_name: nil)
      return if title_name.nil?

      rows = SheetData.get_rows(
        sheet_id: ENV.fetch('UNITE_ATTACKS_SHEET_ID'),
        range: "TK!A1:G"
      )

      result = {}

      result['titleName'] = '幻想水滸伝ティアクライス'
      result['attacks'] = []

      rows.each_with_index do |row, i|
        next if i == 0 || row[1].nil?

        target_hash = {}

        target_hash['id'] = row[0]
        target_hash['name'] = row[1]
        target_hash['characterNames'] = []

        target_hash['characterNames'] << row[2] if row[2]
        target_hash['characterNames'] << row[3] if row[3]
        target_hash['characterNames'] << row[4] if row[4]
        target_hash['characterNames'] << row[5] if row[5]
        target_hash['characterNames'] << row[6] if row[6]
        target_hash['characterNames'] << row[7] if row[7] # 幻水V だけ

        result['attacks'] << target_hash
      end

      puts result.to_json
    end
  end
end
