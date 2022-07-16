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
          @each_rank_tweet_templates = []
        end

        def exec
          ranking = CountingAllCharacter.ranking
          written_data = []

          ranking.each_with_index do |rank_item, index|
            row = []
            character_name = rank_item[:name]

            is_exists_in_character_db = Character.where(name: character_name).present?
            product_names_for_tweet = is_exists_in_character_db ? Presenter::Common.formatted_product_names_for_tweet(character_name) : ''

            result_illustaration_characters = OnRawSheetResultIllustrationTotalling.pluck(:character_name_by_sheet_totalling).reject { |cell| cell.start_with?('TEMP_') }
            is_fav_quotes_exists = character_name.in?(CountingBonusVote.all_fav_quote_character_names_including_duplicated)

            row[@column_name_to_index_hash[:id]] = index + 1
            row[@column_name_to_index_hash[:順位]] = rank_item[:rank]
            row[@column_name_to_index_hash[:キャラ名]] = character_name
            row[@column_name_to_index_hash[:得票数]] = rank_item[:number_of_votes]
            row[@column_name_to_index_hash[:開票イラストがある？]] = character_name.in?(result_illustaration_characters)
            row[@column_name_to_index_hash[:推しセリフがある？]] = is_fav_quotes_exists
            row[@column_name_to_index_hash[:登場作品名]] = product_names_for_tweet
            row[@column_name_to_index_hash[:キャラDBに存在する？]] = is_exists_in_character_db
            row[@column_name_to_index_hash[:ツイートテンプレ]] = tweet_template(rank_item, ranking)

            written_data << row

            Rails.logger.debug { "index: #{index} / #{rank_item[:rank]}位 #{character_name} #{rank_item[:number_of_votes]}票" }
          end

          delete
          write(written_data)
        end

        def tweet_template(rank_item, ranking)
          rank = rank_item[:rank]

          memo = @each_rank_tweet_templates.find { |template| template[:rank] == rank }
          return memo[:text] if memo.present?

          number_of_votes = rank_item[:number_of_votes]
          exist_same_rank = rank_item[:exist_same_rank]
          names_on_the_same_rank = ranking.find_all { |item| item[:rank] == rank }.pluck(:name)

          text_rank_and_votes = "[第#{rank}位] #{number_of_votes}票"
          text_exist_same_rank = exist_same_rank ? "※同率順位あり\n" : ''
          text_hashtags = "#幻水総選挙開票中\n#幻水総選挙2022"

          text_names_and_products = ''
          names_on_the_same_rank.each do |character_name|
            product_names_for_tweet = ''
            product_names_for_tweet = Presenter::Common.formatted_product_names_for_tweet(character_name) if Character.where(name: character_name).present?

            text_names_and_products += "#{character_name} #{product_names_for_tweet}\n"
          end
          text_names_and_products.chomp!

          inserted_hash = {}
          inserted_hash[:rank] = rank
          inserted_hash[:text] = <<~TWEET
            #{text_rank_and_votes}
            #{text_names_and_products}
            #{text_exist_same_rank}
            #{text_hashtags}
          TWEET
          inserted_hash[:text].chomp!

          @each_rank_tweet_templates << inserted_hash

          inserted_hash[:text]
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
            range: "#{@sheet_name}!A2:K501",
            values: [[''] * 11] * 500 # A列からK列までの 11列 x 500行 を空文字で埋める
          )
        end
      end
    end
  end
end
