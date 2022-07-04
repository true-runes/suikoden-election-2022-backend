module Sheets
  module Counting
    class BonusVotes
      def self.import_via_tweet
        ActiveRecord::Base.transaction do
          sheet_names.each_with_index do |sheet_name, i|
            bonus_category_to_sheet_id.each do |bonus_category, this_sheet_id|
              next if this_sheet_id.blank?

              rows = SheetData.get_rows(sheet_id: this_sheet_id, range: "#{sheet_names[i]}!A2:Q101")

              rows.each do |row|
                column_vs_value = column_vs_value(row)

                next if column_vs_value[:id_on_sheet].blank? || column_vs_value[:tweet_id_number].blank? || column_vs_value[:screen_name].blank? || column_vs_value[:contents].blank?

                tweet_id, user_id, this_is_recovered = define_or_create_tweet_and_user_and_is_recovered(sheet_name, column_vs_value)

                unique_attrs = {
                  id_on_sheet: column_vs_value[:id_on_sheet],
                  user_id: user_id,
                  vote_method: :by_tweet,
                  bonus_category: bonus_category,
                  is_recovered: this_is_recovered,
                  tweet_id: tweet_id,
                  contents: column_vs_value[:contents],
                }

                mutable_attrs = {
                  # 123456,654321,777777 のような文字列になる
                  other_tweet_ids_text: column_vs_value[:other_tweet_ids_text].split('|').map(&:strip).join(','),
                  is_invisible: column_vs_value[:is_invisible].to_boolean,
                  is_out_of_counting: column_vs_value[:is_out_of_counting].to_boolean,
                  memo: column_vs_value[:memo],
                  chara_01: column_vs_value[:input_01],
                  chara_02: column_vs_value[:input_02],
                  chara_03: column_vs_value[:input_03],
                  chara_04: column_vs_value[:input_04],
                  chara_05: column_vs_value[:input_05],
                  chara_06: column_vs_value[:input_06],
                  chara_07: column_vs_value[:input_07],
                  chara_08: column_vs_value[:input_08],
                  chara_09: column_vs_value[:input_09],
                  chara_10: column_vs_value[:input_10]
                }

                CountingBonusVote.find_or_initialize_by(unique_attrs).update!(mutable_attrs)
              end
            end
          end
        end

        '[DONE] Sheets::Counting::BonusVotes.import_via_tweet'
      end

      def self.import_via_dm
        ActiveRecord::Base.transaction do
          sheet_names.each_with_index do |sheet_name, i|
            rows = SheetData.get_rows(sheet_id: ENV.fetch('COUNTING_DIRECT_MESSAGES_SHEET_ID', nil), range: "#{sheet_names[i]}!A2:Q101")

            rows.each do |row|
              dm_column_vs_value = dm_column_vs_value(row)

              next unless dm_column_vs_value[:category].in?(dm_target_categories)

              next if dm_column_vs_value[:id_on_sheet].blank? || dm_column_vs_value[:dm_id_number].blank? || dm_column_vs_value[:screen_name].blank? || dm_column_vs_value[:contents].blank?

              dm_id, user_id, this_is_recovered = define_or_create_dm_and_user_and_is_recovered(sheet_name, dm_column_vs_value)

              unique_attrs = {
                id_on_sheet: dm_column_vs_value[:id_on_sheet],
                user_id: user_id,
                vote_method: :by_direct_message,
                bonus_category: dm_sheet_category_to_bonus_category[dm_column_vs_value[:category]],
                direct_message_id: dm_id,
                is_recovered: this_is_recovered,
                other_tweet_ids_text: nil,
                contents: dm_column_vs_value[:contents],
              }

              mutable_attrs = {
                is_invisible: dm_column_vs_value[:is_invisible].to_boolean,
                is_out_of_counting: dm_column_vs_value[:is_out_of_counting].to_boolean,
                memo: dm_column_vs_value[:memo],
                chara_01: dm_column_vs_value[:input_01],
                chara_02: dm_column_vs_value[:input_02],
                chara_03: dm_column_vs_value[:input_03],
                chara_04: dm_column_vs_value[:input_04],
                chara_05: dm_column_vs_value[:input_05],
                chara_06: dm_column_vs_value[:input_06],
                chara_07: dm_column_vs_value[:input_07],
                chara_08: dm_column_vs_value[:input_08],
                chara_09: dm_column_vs_value[:input_09],
                chara_10: dm_column_vs_value[:input_10]
              }

              CountingBonusVote.find_or_initialize_by(unique_attrs).update!(mutable_attrs)
            end

            puts "#{sheet_names[i]} is Done." # rubocop:disable Rails/Output
          end
        end

        '[DONE] Sheets::Counting::BonusVotes.import_via_dm'
      end

      def self.define_or_create_tweet_and_user_and_is_recovered(sheet_name, column_vs_value)
        if sheet_name == '取得漏れ等'
          # Tweetを作ってしまうとシートに流し込んだときにズレるので絶対に駄目
          tweet_id = nil
          this_is_recovered = true

          existing_user = User.find_by(screen_name: column_vs_value[:screen_name])

          if existing_user.blank?
            client = TwitterRestApi.client
            # ここで API を消費する
            user = client.user(column_vs_value[:screen_name])

            new_user = User.new(
              id_number: user.id,
              name: user.name,
              screen_name: user.screen_name,
              profile_image_url_https: user.profile_image_url_https.to_s,
              is_protected: user.protected?,
              born_at: user.created_at
            )
            new_user.save!

            user_id = user.id
          else
            user_id = existing_user.id
          end
        else
          tweet = Tweet.find_by(id_number: column_vs_value[:tweet_id_number])

          tweet_id = tweet.id
          user_id = tweet.user.id
          this_is_recovered = false
        end

        [tweet_id, user_id, this_is_recovered]
      end

      def self.dm_sheet_category_to_bonus_category
        {
          'ボ・OP・CLイラスト' => :op_cl_illustrations,
          'ボ・お題小説' => :short_stories,
          'ボ・開票イラスト' => :result_illustrations,
          'ボ・推し台詞' => :fav_quotes,
          'ボ・選挙運動' => :sosenkyo_campaigns
        }
      end

      def self.bonus_category_to_sheet_id
        {
          op_cl_illustrations: nil, # これは DM で受け取る
          short_stories: ENV.fetch('COUNTING_BONUS_SHORT_STORIES_SHEET_ID', nil),
          result_illustrations: nil, # シートの設計が根本的に違う
          fav_quotes: ENV.fetch('COUNTING_BONUS_FAV_QUOTES_SHEET_ID', nil),
          sosenkyo_campaigns: ENV.fetch('COUNTING_BONUS_SOSENKYO_CAMPAIGNS_SHEET_ID', nil)
        }
      end

      def self.sheet_names
        YAML.load_file(Rails.root.join('config/counting_sheet_names.yml'))['names']
      end

      def self.column_vs_value(row)
        {
          id_on_sheet: row[0],
          screen_name: row[1],
          tweet_id_number: row[2],
          other_tweet_ids_text: row[5],
          is_invisible: row[7], # "FALSE" のような文字列なので注意
          is_out_of_counting: row[8], # "FALSE" のような文字列なので注意
          contents: row[11],
          memo: row[12],
          input_01: row[14],
          input_02: row[15],
          input_03: row[16],
          input_04: row[17],
          input_05: row[18],
          input_06: row[19],
          input_07: row[20],
          input_08: row[21],
          input_09: row[22],
          input_10: row[23]
        }
      end

      def self.dm_column_vs_value(row)
        {
          id_on_sheet: row[0],
          screen_name: row[1],
          dm_id_number: row[2],
          is_invisible: row[5], # "FALSE" のような文字列なので注意
          is_out_of_counting: row[6], # "FALSE" のような文字列なので注意
          category: row[9],
          contents: row[10],
          memo: row[11],
          input_01: row[13],
          input_02: row[14],
          input_03: row[15],
          input_04: row[16],
          input_05: row[17],
          input_06: row[18],
          input_07: row[19],
          input_08: row[20],
          input_09: row[21],
          input_10: row[22]
        }
      end

      def self.dm_target_categories
        [
          'ボ・OP・CLイラスト',
          'ボ・お題小説',
          'ボ・開票イラスト',
          'ボ・推し台詞',
          'ボ・選挙運動',
        ]
      end

      def self.define_or_create_dm_and_user_and_is_recovered(sheet_name, dm_column_vs_value)
        user = create_or_find_by_user(dm_column_vs_value)

        if sheet_name == '取得漏れ等'
          dm_id = nil
          user_id = user.id
          this_is_recovered = true
        else
          dm = DirectMessage.find_by(id_number: dm_column_vs_value[:dm_id_number])

          dm_id = dm&.id
          user_id = dm&.user&.id || user.id
          this_is_recovered = false
        end

        [dm_id, user_id, this_is_recovered]
      end

      # screen_name はあまり良くない
      def self.create_or_find_by_user(dm_column_vs_value)
        existing_user = User.find_by(screen_name: dm_column_vs_value[:screen_name])

        if existing_user.blank?
          client = TwitterRestApi.client
          # ここで API を消費する
          user = client.user(dm_column_vs_value[:screen_name])

          new_user = User.new(
            id_number: user.id,
            name: user.name,
            screen_name: user.screen_name,
            profile_image_url_https: user.profile_image_url_https.to_s,
            is_protected: user.protected?,
            born_at: user.created_at
          )
          new_user.save!

          new_user
        else
          existing_user
        end
      end
    end
  end
end
