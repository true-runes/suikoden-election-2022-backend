module Sheets
  module WriteAndUpdate
    module FinalResults
      module BonusVotes
        class SosenkyoCampaigns < Sheets::WriteAndUpdate::FinalResults::BonusVotes::Base
          NUMBER_OF_BONUS_VOTES = 2

          def exec
            records = CountingBonusVote.ranking_sosenkyo_campaigns
            tally_by_character = records.pluck(:character_name).tally

            rows = []

            tally_by_character.each_with_index do |(character_name, number_of_votes), index|
              row = []

              row[@column_name_to_index_hash[:id]] = index + 1
              row[@column_name_to_index_hash[:キャラ名]] = character_name
              row[@column_name_to_index_hash[:投稿数]] = number_of_votes
              row[@column_name_to_index_hash[:最終集計得票数]] = NUMBER_OF_BONUS_VOTES

              rows << row
            end

            delete
            write(rows)
          end

          private

          def this_sheet_name
            'ボ・選挙運動'
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
              range: "#{@sheet_name}!A2:D501",
              values: [[''] * 4] * 500 # A列からD列までの列の x 500行 を空文字で埋める
            )
          end

          def this_column_name_to_index_hash
            {
              id: 0,
              キャラ名: 1,
              投稿数: 2,
              最終集計得票数: 3
            }
          end
        end
      end
    end
  end
end
