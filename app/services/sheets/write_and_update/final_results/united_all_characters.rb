module Sheets
  module WriteAndUpdate
    module FinalResults
      class UnitedAllCharacters
        attr_reader :united_rows

        def initialize
          puts '[LOG] FinalResults::UnitedAllCharacters.initialize 開始' # rubocop:disable Rails/Output

          @sheet_name = '最終・①オールキャラ部門'
          @column_name_to_index_hash = {
            id: 0,
            順位: 1,
            キャラ名: 2,
            全得票数: 3,
            # "": 4,
            部門得票数: 5,
            ボ・OP・CLイラスト: 6,
            ボ・お題小説: 7,
            ボ・開票イラスト: 8,
            ボ・推し台詞: 9,
            ボ・選挙運動: 10,
            # "": 11,
            開票イラストがある？: 12,
            推しセリフがある？: 13,
            登場作品名: 14,
            キャラDBに存在する？: 15,
            ツイートテンプレート: 16
          }
          @all_characters_rows = all_characters_rows
          @bonus_short_stories_rows = bonus_short_stories_rows
          @bonus_fav_quotes_rows = bonus_fav_quotes_rows
          @bonus_result_illustrations_rows = bonus_result_illustrations_rows
          @bonus_campaigns_rows = bonus_campaigns_rows
          @bonus_op_cl_rows = bonus_op_cl_rows

          puts '[LOG] シート別インスタンス変数の生成完了' # rubocop:disable Rails/Output

          @united_rows = []

          all_character_names = @all_characters_rows.pluck(:character_name).push(@bonus_short_stories_rows.pluck(:character_name))
                                                    .push(@bonus_fav_quotes_rows.pluck(:character_name)).push(@bonus_result_illustrations_rows.pluck(:character_name))
                                                    .push(@bonus_campaigns_rows.pluck(:character_name)).push(@bonus_op_cl_rows.pluck(:character_name))
          all_character_names.flatten!.uniq!

          all_character_names.each do |character_name|
            character_in_all_characters_rows = @all_characters_rows.find { |row| row[:character_name] == character_name }

            this_character_number_of_bonus_votes = set_this_character_number_of_bonus_votes(character_name)
            this_number_of_division_votes = character_in_all_characters_rows.blank? ? 0 : character_in_all_characters_rows[:number_of_votes]
            this_result_illustration_exist = this_character_number_of_bonus_votes[:result_illustrations].positive?
            this_fav_quotes_exist = this_character_number_of_bonus_votes[:fav_quotes].positive?
            this_product_names = Presenter::Common.formatted_product_names_for_tweet(character_name)
            this_exist_in_character_db = Character.exists?(name: character_name)

            @united_rows << {
              character_name: fixed_character_name(character_name),
              number_of_division_votes: this_number_of_division_votes,
              number_of_bonus_votes: this_character_number_of_bonus_votes,
              united_number_of_votes: this_number_of_division_votes + this_character_number_of_bonus_votes.values.sum,
              result_illustration_exist: this_result_illustration_exist.to_s.upcase,
              fav_quotes_exist: this_fav_quotes_exist.to_s.upcase,
              product_names: this_product_names,
              exist_in_character_db: this_exist_in_character_db.to_s.upcase
            }
          end

          @united_rows.sort_by! do |row|
            # 票数の降順でソートする
            [
              -row[:united_number_of_votes], row[:character_name]
            ]
          end

          @united_rows = set_rank(@united_rows)
          @united_rows = set_exist_same_rank(@united_rows)

          @memoized_tweet_templates = []
          @united_rows = set_tweet_template(@united_rows)

          puts '[LOG] 全シートを結合したデータの生成完了' # rubocop:disable Rails/Output
        end

        def exec
          rows = []

          @united_rows.each_with_index do |united_row, index|
            row = []

            row[@column_name_to_index_hash[:id]] = index + 1
            row[@column_name_to_index_hash[:順位]] = united_row[:rank]
            row[@column_name_to_index_hash[:キャラ名]] = united_row[:character_name]
            row[@column_name_to_index_hash[:全得票数]] = united_row[:united_number_of_votes]
            row[@column_name_to_index_hash[:部門得票数]] = united_row[:number_of_division_votes]
            row[@column_name_to_index_hash[:ボ・OP・CLイラスト]] = united_row.dig(:number_of_bonus_votes, :op_cl)
            row[@column_name_to_index_hash[:ボ・お題小説]] = united_row.dig(:number_of_bonus_votes, :short_stories)
            row[@column_name_to_index_hash[:ボ・開票イラスト]] = united_row.dig(:number_of_bonus_votes, :result_illustrations)
            row[@column_name_to_index_hash[:ボ・推し台詞]] = united_row.dig(:number_of_bonus_votes, :fav_quotes)
            row[@column_name_to_index_hash[:ボ・選挙運動]] = united_row.dig(:number_of_bonus_votes, :campaigns)
            row[@column_name_to_index_hash[:開票イラストがある？]] = united_row[:result_illustration_exist]
            row[@column_name_to_index_hash[:推しセリフがある？]] = united_row[:fav_quotes_exist]
            row[@column_name_to_index_hash[:登場作品名]] = united_row[:product_names]
            row[@column_name_to_index_hash[:キャラDBに存在する？]] = united_row[:exist_in_character_db]
            row[@column_name_to_index_hash[:ツイートテンプレート]] = united_row[:tweet_template]

            rows << row
          end

          delete
          write(rows)
        end

        def write(written_data)
          SheetData.write_rows(
            sheet_id: final_results_sheet_id,
            range: "#{@sheet_name}!A2", # 始点
            values: written_data
          )
        end

        def delete
          SheetData.write_rows(
            sheet_id: final_results_sheet_id,
            range: "#{@sheet_name}!A2:Q501",
            values: [[''] * 17] * 500 # A列からQ列までの 17列 x 500行 を空文字で埋める
          )
        end

        # 単体・①オールキャラ部門
        def all_characters_rows
          sheet_name = '単体・①オールキャラ部門'
          rows = SheetData.get_rows(sheet_id: final_results_sheet_id, range: "#{sheet_name}!B2:L501")
          all_characters_rows = []

          rows.each do |row|
            all_characters_rows << {
              rank: row[0],
              character_name: row[1],
              number_of_votes: row[2].to_i,
              result_illustration_exist: row[4],
              fav_quotes_exist: row[5],
              product_names: row[6],
              exist_in_character_db: row[7],
              tweet_template: row[9]
            }
          end

          all_characters_rows
        end

        # ボ・お題小説
        def bonus_short_stories_rows
          sheet_name = 'ボ・お題小説'
          rows = SheetData.get_rows(sheet_id: final_results_sheet_id, range: "#{sheet_name}!B2:L501")
          bonus_short_stories_rows = []

          rows.each do |row|
            bonus_short_stories_rows << {
              character_name: row[0],
              number_of_votes: row[2].to_i
            }
          end

          bonus_short_stories_rows
        end

        # ボ・推し台詞
        def bonus_fav_quotes_rows
          sheet_name = 'ボ・推し台詞'
          rows = SheetData.get_rows(sheet_id: final_results_sheet_id, range: "#{sheet_name}!B2:L501")
          bonus_fav_quotes_rows = []

          rows.each do |row|
            bonus_fav_quotes_rows << {
              character_name: row[0],
              number_of_votes: row[2].to_i
            }
          end

          bonus_fav_quotes_rows
        end

        # ボ・開票イラスト
        def bonus_result_illustrations_rows
          sheet_name = 'ボ・開票イラスト'
          rows = SheetData.get_rows(sheet_id: final_results_sheet_id, range: "#{sheet_name}!B2:L501")
          bonus_result_illustrations_rows = []

          rows.each do |row|
            bonus_result_illustrations_rows << {
              character_name: row[0],
              number_of_votes: row[2].to_i
            }
          end

          bonus_result_illustrations_rows
        end

        # ボ・選挙運動
        def bonus_campaigns_rows
          sheet_name = 'ボ・選挙運動'
          rows = SheetData.get_rows(sheet_id: final_results_sheet_id, range: "#{sheet_name}!B2:L501")
          bonus_campaigns_rows = []

          rows.each do |row|
            bonus_campaigns_rows << {
              character_name: row[0],
              number_of_votes: row[2].to_i
            }
          end

          bonus_campaigns_rows
        end

        # ボ・OP・CLイラスト（オールキャラ）
        def bonus_op_cl_rows
          sheet_name = 'ボ・OP・CLイラスト（オールキャラ）'
          rows = SheetData.get_rows(sheet_id: final_results_sheet_id, range: "#{sheet_name}!B2:L501")
          bonus_op_cl_rows = []

          rows.each do |row|
            bonus_op_cl_rows << {
              character_name: row[0],
              number_of_votes: row[1].to_i
            }
          end

          bonus_op_cl_rows
        end

        private

        def fixed_character_name(character_name)
          {
            'ザジ・キュイロス' => 'ザジ・キュイロス（サナトス・クロフォード）',
            'ジョウイ・アトレイド（ブライト）' => 'ジョウイ・アトレイド（ジョウイ・ブライト）',
            'ナッシュ・ラトキエ（クロービス）' => 'ナッシュ・ラトキエ（ナッシュ・クロービス）'
          }[character_name] || character_name
        end

        def set_tweet_template(united_rows)
          with_tweet_template_united_rows = []

          united_rows.each do |united_row|
            rank = united_row[:rank]
            memo = @memoized_tweet_templates.find { |template| template[:rank] == rank }

            if memo.present?
              with_tweet_template_united_rows << {
                tweet_template: memo[:tweet_template]
              }.merge(united_row)

              next
            end

            number_of_votes = united_row[:united_number_of_votes]
            exist_same_rank = united_row[:exist_same_rank]

            names_on_the_same_rank = united_rows.find_all { |u_row| u_row[:rank] == rank }.pluck(:character_name)

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

            tmp_hash = {}
            tmp_hash[:tweet_template] = <<~TWEET
              #{text_rank_and_votes}
              #{text_names_and_products}
              #{text_exist_same_rank}
              #{text_hashtags}
            TWEET
            tmp_hash[:tweet_template].chomp!

            # メモ化
            @memoized_tweet_templates << {
              rank: rank,
              tweet_template: tmp_hash[:tweet_template]
            }

            with_tweet_template_united_rows << tmp_hash.merge(united_row)
          end

          with_tweet_template_united_rows
        end

        def final_results_sheet_id
          ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil)
        end

        # united_rows は票数の降順でソートされているものとする
        def set_rank(united_rows)
          current_rank = 1
          with_rank_united_rows = []

          united_rows.each_with_index do |united_row, index|
            tmp_hash = {}

            if index == 0
              tmp_hash[:rank] = current_rank
            else
              previous_number_of_votes = united_rows[index - 1][:united_number_of_votes]

              if united_row[:united_number_of_votes] == previous_number_of_votes
                tmp_hash[:rank] = current_rank
              else
                tmp_hash[:rank] = current_rank + 1

                current_rank += 1
              end
            end

            with_rank_united_rows << tmp_hash.merge(united_row)
          end

          with_rank_united_rows
        end

        # set_rank 済みの united_rows が引数となる（すさまじい密結合）
        def set_exist_same_rank(united_rows)
          with_exist_same_rank_united_rows = []

          united_rows.each_with_index do |united_row, index|
            tmp_hash = {}

            tmp_hash[:exist_same_rank] = case index
                                         when 0
                                          united_row[:rank] == united_rows[1][:rank]
                                         when united_rows.size - 1
                                          united_row[:rank] == united_rows[index - 1][:rank]
                                         else
                                          united_row[:rank] == united_rows[index - 1][:rank] || united_row[:rank] == united_rows[index + 1][:rank]
                                  end

            with_exist_same_rank_united_rows << tmp_hash.merge(united_row)
          end

          with_exist_same_rank_united_rows
        end

        def set_this_character_number_of_bonus_votes(character_name)
          this_character_number_of_bonus_votes = {}

          this_character_number_of_bonus_votes[:short_stories] = @bonus_short_stories_rows.find do |bonus_short_story_row|
            bonus_short_story_row[:character_name] == character_name
          end.try(:[], :number_of_votes) || 0

          this_character_number_of_bonus_votes[:fav_quotes] = @bonus_fav_quotes_rows.find do |bonus_fav_quote_row|
            bonus_fav_quote_row[:character_name] == character_name
          end.try(:[], :number_of_votes) || 0

          this_character_number_of_bonus_votes[:result_illustrations] = @bonus_result_illustrations_rows.find do |bonus_result_illustration_row|
            bonus_result_illustration_row[:character_name] == character_name
          end.try(:[], :number_of_votes) || 0

          this_character_number_of_bonus_votes[:campaigns] = @bonus_campaigns_rows.find do |bonus_campaign_row|
            bonus_campaign_row[:character_name] == character_name
          end.try(:[], :number_of_votes) || 0

          this_character_number_of_bonus_votes[:op_cl] = @bonus_op_cl_rows.find do |bonus_op_cl_row|
            bonus_op_cl_row[:character_name] == character_name
          end.try(:[], :number_of_votes) || 0

          this_character_number_of_bonus_votes
        end
      end
    end
  end
end
