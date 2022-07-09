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
            フリガナ: 5,
            ツイートテンプレ: 6
          }
        end

        def exec
          hash_records = CountingUniteAttack.valid_records.ranking
          key_to_rank_number = Presenter::Counting.key_to_rank_number_by_sosenkyo_style(hash_records)
          written_data = []

          hash_records.each_with_index do |(product_name_and_attack_name_and_kana, number_of_votes), index|
            row = []
            product_name = product_name_and_attack_name_and_kana[0]
            attack_name = product_name_and_attack_name_and_kana[1]
            kana = product_name_and_attack_name_and_kana[2]
            # tweet_template = tweet_template(key_to_rank_number[index], hash_records)

            row[@column_name_to_index_hash[:id]] = index + 1
            row[@column_name_to_index_hash[:順位]] = key_to_rank_number[product_name_and_attack_name_and_kana]
            row[@column_name_to_index_hash[:作品名]] = product_name
            row[@column_name_to_index_hash[:協力攻撃名]] = attack_name
            row[@column_name_to_index_hash[:全得票数]] = number_of_votes
            row[@column_name_to_index_hash[:フリガナ]] = kana
            # row[@column_name_to_index_hash[:ツイートテンプレ]] = kana

            written_data << row
          end

          delete

          write(written_data.sort_by { |row| [row[1], row[5]] })
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
            range: "#{@sheet_name}!A2:G501",
            values: [[''] * 7] * 500 # A列からG列までの列の 500行 を空文字で埋める
          )
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
      end
    end
  end
end
