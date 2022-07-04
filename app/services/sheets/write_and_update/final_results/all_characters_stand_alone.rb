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
            推しセリフがある？: 6,
            登場作品名: 7,
            キャラDBに存在する？: 8,
            ツイートテンプレ: 10
          }
        end

        def exec
          hash_records = CountingAllCharacter.character_name_to_number_of_votes
          key_to_rank_number = Presenter::Counting.key_to_rank_number_by_sosenkyo_style(hash_records)
          written_data = []

          hash_records.each_with_index do |(character_name, number_of_votes), index|
            row = []

            is_exists_in_character_db = Character.where(name: character_name).present?
            product_names = is_exists_in_character_db ? Presenter::Common.formatted_product_names_for_tweet(character_name) : ''

            # シートのキャラ名表記がキャラDBのキャラ名表記とは異なるので、対応表を作成して対処している
            on_sheet_name_to_on_db_name = YAML.load_file(
              Rails.root.join('config/character_names_on_result_illustrations_sheet.yml')
            )['on_database_character_name_to_on_sheet_character_name']
            fixed_character_name = on_sheet_name_to_on_db_name[character_name] || character_name

            result_illustaration_characters = OnRawSheetResultIllustrationTotalling.pluck(:character_name_for_public)
            is_fav_quotes_exists = character_name.in?(CountingBonusVote.all_fav_quote_character_names_including_duplicated)

            row[@column_name_to_index_hash[:id]] = index + 1
            row[@column_name_to_index_hash[:順位]] = key_to_rank_number[character_name]
            row[@column_name_to_index_hash[:キャラ名]] = character_name
            row[@column_name_to_index_hash[:得票数]] = number_of_votes
            row[@column_name_to_index_hash[:開票イラストがある？]] = fixed_character_name.in?(result_illustaration_characters)
            row[@column_name_to_index_hash[:推しセリフがある？]] = is_fav_quotes_exists
            row[@column_name_to_index_hash[:登場作品名]] = product_names
            row[@column_name_to_index_hash[:キャラDBに存在する？]] = is_exists_in_character_db
            row[@column_name_to_index_hash[:ツイートテンプレ]] = tweet_template(
              rank: key_to_rank_number[character_name],
              number_of_votes: number_of_votes,
              character_name: character_name,
              product_names: product_names
            )

            written_data << row
          end

          write(written_data)
        end

        def tweet_template(rank: nil, number_of_votes: nil, character_name: nil, product_names: nil)
          <<~TWEET
            [第#{rank}位] #{number_of_votes}票
            #{character_name} #{product_names}

            #幻水総選挙開票中
          TWEET
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
