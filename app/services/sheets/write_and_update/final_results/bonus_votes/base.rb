module Sheets
  module WriteAndUpdate
    module FinalResults
      module BonusVotes
        class Base
          REQUIRED_SHEET_NAMES = [
            'ボ・お題小説',
            'ボ・推し台詞',
            'ボ・開票イラスト',
            'ボ・選挙運動',
            'ボ・OP・CLイラスト（オールキャラ）',
            'ボ・OP・CLイラスト（協力攻撃）', # 未使用
          ].freeze

          def initialize(sheet_name)
            return unless sheet_name.in?(REQUIRED_SHEET_NAMES)

            @sheet_name = sheet_name
            @column_name_to_index_hash = column_name_to_index_hash
          end

          def exec(written_sheet_name)
            # enum_symbol = sheet_name_to_enum_symbol(@sheet_name)
            # hash_records = CountingBonusVote.valid_records.where(bonus_category: enum_symbol)

            return unless written_sheet_name.in?(REQUIRED_SHEET_NAMES)

            hash_records = CountingBonusVote.ranking(@sheet_name)

            # key_to_rank_number = Presenter::Counting.key_to_rank_number_by_sosenkyo_style(hash_records)
            # written_data = []

            # hash_records.each_with_index do |(product_name_and_attack_name, number_of_votes), index|
            #   row = []
            #   product_name = product_name_and_attack_name[0]
            #   attack_name = product_name_and_attack_name[1]

            #   row[@column_name_to_index_hash[:id]] = index + 1
            #   row[@column_name_to_index_hash[:順位]] = key_to_rank_number[product_name_and_attack_name]
            #   row[@column_name_to_index_hash[:作品名]] = product_name
            #   row[@column_name_to_index_hash[:協力攻撃名]] = attack_name
            #   row[@column_name_to_index_hash[:全得票数]] = number_of_votes

            #   written_data << row
            # end

            # delete

            # # TODO: 「ふりがな」を使いたい
            # write(written_data.sort_by { |row| [row[1], row[3], row[2]] })
          end

          def write(written_data)
            # SheetData.write_rows(
            #   sheet_id: ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil),
            #   range: "#{@sheet_name}!A2", # 始点
            #   values: written_data
            # )
          end

          def delete
            # SheetData.write_rows(
            #   sheet_id: ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil),
            #   range: "#{@sheet_name}!A2:E501",
            #   values: [[''] * 5] * 500 # A列からE列までの 5列 x 500行 を空文字で埋める
            # )
          end

          private

          def column_name_to_index_hash
            raise
          end

          # def column_name_to_index_hash(sheet_name)
          #   case sheet_name
          #   when 'ボ・お題小説'
          #     {
          #       id: 0,
          #       キャラ名: 1,
          #       お題: 2,
          #       素得票数: 3,
          #       実得票数: 4
          #     }
          #   when 'ボ・推し台詞', 'ボ・開票イラスト', 'ボ・選挙運動'
          #     {
          #       id: 0,
          #       キャラ名: 1,
          #       素得票数: 2,
          #       実得票数: 3
          #     }
          #   when 'ボ・OP・CLイラスト（オールキャラ）'
          #     {
          #       id: 0,
          #       キャラ名1: 1,
          #       キャラ名2: 2,
          #       キャラ名3: 3
          #     }
          #   when 'ボ・OP・CLイラスト（協力攻撃）'
          #     {
          #       id: 0,
          #       作品名: 1,
          #       攻撃名: 2
          #     }
          #   end
          # end

          # TODO: 不要っぽいので不要なら削除する
          def sheet_name_to_enum_symbol(sheet_name)
            {
              'ボ・お題小説' => :short_stories,
              'ボ・推し台詞' => :fav_quotes,
              'ボ・開票イラスト' => :result_illustrations,
              'ボ・選挙運動' => :sosenkyo_campaigns,
              'ボ・OP・CLイラスト（オールキャラ）' => :op_cl_illustrations,
              'ボ・OP・CLイラスト（協力攻撃）' => :op_cl_illustrations
            }[sheet_name]
          end
        end
      end
    end
  end
end
