# ボーナス票・推し台詞
module Sheets
  module WriteAndUpdate
    module FinalResults
      class AllCharactersStandAlone
        def initialize
          @sheet_name = '単体・①オールキャラ部門'
          @column_name_to_index_hash = {
            id: 0,
            順位: 1,
            キャラ名: 2,
            得票数: 3,
            開票イラストがある？: 5,
            # CountingBonusVote.valid_records.where(bonus_category: :fav_quotes).pluck(:chara_01...)
            推しセリフがある？: 6,
            登場作品名: 7,
            キャラDBに存在する？: 8
          }
        end

        def exec
          hash_records = CountingAllCharacter.character_name_to_number_of_votes
          key_to_rank_number = Presenter::Counting.key_to_rank_number_by_sosenkyo_style(hash_records)
          written_data = []

          hash_records.each_with_index do |(character_name, number_of_votes), index|
            row = []

            is_exists_in_character_db = Character.where(name: character_name).present?
            product_names = is_exists_in_character_db ? Character.find_by(name: character_name).products.pluck(:name).join(',') : ''

            is_fav_quotes_exists = character_name.in?(CountingBonusVote.all_fav_quote_character_names_including_duplicated)

            # FIXME: 表記がDBと違うので修正する
            result_illustaration_characteres = OnRawSheetResultIllustrationTotalling.pluck(:character_name_for_public)

            row[@column_name_to_index_hash[:id]] = index + 1
            row[@column_name_to_index_hash[:順位]] = key_to_rank_number[character_name]
            row[@column_name_to_index_hash[:キャラ名]] = character_name
            row[@column_name_to_index_hash[:得票数]] = number_of_votes
            row[@column_name_to_index_hash[:開票イラストがある？]] = character_name.in?(result_illustaration_characteres)
            row[@column_name_to_index_hash[:推しセリフがある？]] = is_fav_quotes_exists
            row[@column_name_to_index_hash[:登場作品名]] = product_names
            row[@column_name_to_index_hash[:キャラDBに存在する？]] = is_exists_in_character_db

            written_data << row
          end

          write(written_data)
        end

        # TODO: 切り出せそう
        def write(written_data)
          SheetData.write_rows(
            sheet_id: ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil),
            range: "#{@sheet_name}!A2", # 始点
            values: written_data
          )
        end

        # TODO: 切り出せそう
        def delete
          SheetData.write_rows(
            sheet_id: ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil),
            range: "#{@sheet_name}!A2:T500",
            values: [[''] * 20] * 500
          )
        end
      end
    end
  end
end
