module Sheets
  module WriteAndUpdate
    module FinalResults
      class UniteAttacks
        def initialize
          @sheet_name = '②協力攻撃部門'
          @column_name_to_index_hash = {
            id: 0,
            順位: 1,
            作品名: 2,
            協力攻撃名: 3,
            全得票数: 4,
            投票方法内訳・ツイート: 8,
            投票方法内訳・DM: 9
          }
        end

        def exec
          hash_records = CountingUniteAttack.valid_records.ranking
          key_to_rank_number = Presenter::Counting.key_to_rank_number_by_sosenkyo_style(hash_records)
          written_data = []

          hash_records.each_with_index do |(product_name_and_attack_name, number_of_votes), index|
            row = []
            product_name = product_name_and_attack_name[0]
            attack_name = product_name_and_attack_name[1]

            row[@column_name_to_index_hash[:id]] = index + 1
            row[@column_name_to_index_hash[:順位]] = key_to_rank_number[product_name_and_attack_name]
            row[@column_name_to_index_hash[:作品名]] = product_name
            row[@column_name_to_index_hash[:協力攻撃名]] = attack_name
            row[@column_name_to_index_hash[:全得票数]] = number_of_votes

            written_data << row
          end

          delete

          # TODO: 「ふりがな」を使いたい
          write(written_data.sort_by { |row| [row[1], row[3], row[2]] })
        end

        def write(written_data)
          SheetData.write_rows(
            sheet_id: ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil),
            range: "#{@sheet_name}!A2", # 始点
            values: written_data
          )
        end

        def delete
          SheetData.write_rows(
            sheet_id: ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil),
            range: "#{@sheet_name}!A2:E501",
            values: [[''] * 5] * 500 # A列からE列までの 5列 x 500行 を空文字で埋める
          )
        end
      end
    end
  end
end
