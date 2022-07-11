module Sheets
  module WriteAndUpdate
    module FinalResults
      module BonusVotes
        class FavQuotes < Sheets::WriteAndUpdate::FinalResults::BonusVotes::Base
          def hoge
            # o = Sheets::WriteAndUpdate::FinalResults::BonusVotes::FavQuotes.new('ボ・お題小説')
            # o.hoge
            # TODO
            @records = CountingBonusVote.ranking(@sheet_name)
          end

          private

          def column_name_to_index_hash
            {
              id: 0,
              投稿方法: 1,
              お題: 2,
              キャラ名: 3,
              素得票数: 4,
              実得票数: 5
            }
          end
        end
      end
    end
  end
end
