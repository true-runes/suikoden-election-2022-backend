module Sheets
  module WriteAndUpdate
    module FinalResults
      module BonusVotes
        class OpClIllustrations < Sheets::WriteAndUpdate::FinalResults::BonusVotes::Base
          def exec
            records = CountingBonusVote.ranking_op_cl_illustrations

            rows = []

            # オールキャラのみ集計する（協力攻撃は DM 扱いでの集計）
            records[:all_characters].each_with_index do |cell_hashes, index|
              character_names = cell_hashes.values

              character_names.each do |character_name|
                row = []

                row[@column_name_to_index_hash[:id]] = index + 1
                row[@column_name_to_index_hash[:キャラ名]] = character_name
                row[@column_name_to_index_hash[:得票数]] = 1

                rows << row
              end
            end

            delete
            write(rows)
          end

          private

          def this_sheet_name
            'ボ・OP・CLイラスト（オールキャラ）'
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
              range: "#{@sheet_name}!A2:C501",
              values: [[''] * 3] * 500 # A列からC列までの列の x 500行 を空文字で埋める
            )
          end

          def this_column_name_to_index_hash
            {
              id: 0,
              キャラ名: 1,
              得票数: 2
            }
          end
        end
      end
    end
  end
end
