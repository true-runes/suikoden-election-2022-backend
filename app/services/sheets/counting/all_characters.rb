module Sheets
  module Counting
    class AllCharacters
      def self.import_via_tweet
        sheet_names = YAML.load_file(Rails.root.join('config/counting_sheet_names.yml'))['names']

        ActiveRecord::Base.transaction do
          sheet_names.each_with_index do |sheet_name, i|
            rows = SheetData.get_rows(sheet_id: ENV.fetch('COUNTING_ALL_CHARACTERS_SHEET_ID', nil), range: "#{sheet_names[i]}!A2:Q101")

            rows.each do |row|
              column_vs_value = {
                id_on_sheet: row[0],
                screen_name: row[1],
                tweet_id_number: row[2],
                other_tweet_ids_text: row[5],
                is_invisible: row[7], # "FALSE" のような文字列なので注意
                is_out_of_counting: row[8], # "FALSE" のような文字列なので注意
                contents: row[11],
                memo: row[12],
                chara_1: row[14],
                chara_2: row[15],
                chara_3: row[16]
              }

              next if column_vs_value[:id_on_sheet].blank? || column_vs_value[:tweet_id_number].blank? || column_vs_value[:contents].blank?

              tweet = Tweet.find_by(id_number: column_vs_value[:tweet_id_number])
              tweet_id = tweet&.id

              user = tweet&.user || create_or_find_by_user(column_vs_value)
              user_id = user&.id

              unique_attrs = {
                id_on_sheet: column_vs_value[:id_on_sheet],
                user_id: user_id,
                vote_method: :by_tweet,
                tweet_id: tweet_id,
                contents: column_vs_value[:contents]
              }

              mutable_attrs = {
                # 123456,654321,777777 のような文字列になる
                other_tweet_ids_text: column_vs_value[:other_tweet_ids_text].split('|').map(&:strip).join(','),
                is_invisible: column_vs_value[:is_invisible].to_boolean,
                is_out_of_counting: column_vs_value[:is_out_of_counting].to_boolean,
                memo: column_vs_value[:memo],
                chara_1: column_vs_value[:chara_1],
                chara_2: column_vs_value[:chara_2],
                chara_3: column_vs_value[:chara_3]
              }

              CountingAllCharacter.find_or_initialize_by(unique_attrs).update!(mutable_attrs)
            end

            puts "#{sheet_name} is Done." # rubocop:disable Rails/Output
          end
        end

        '[DONE] Sheets::Counting::AllCharacters.import_via_tweet'
      end

      def self.import_via_dm
        sheet_names = YAML.load_file(Rails.root.join('config/counting_sheet_names.yml'))['names']

        # rubocop:disable Metrics/BlockLength
        ActiveRecord::Base.transaction do
          sheet_names.each_with_index do |sheet_name, i|
            rows = SheetData.get_rows(sheet_id: ENV.fetch('COUNTING_DIRECT_MESSAGES_SHEET_ID', nil), range: "#{sheet_names[i]}!A2:Q101")

            rows.each do |row|
              # TODO: 設定ファイルを用いてスマートに定義したい
              column_vs_value = {
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

              # DMの書式が自由すぎるので、こちらで条件を吸収する
              next if column_vs_value[:category] != '①オールキャラ部門' && column_vs_value[:category] != '両部門'
              next if column_vs_value[:is_invisible] == 'TRUE' || column_vs_value[:is_out_of_counting] == 'TRUE'
              next if column_vs_value[:id_on_sheet].blank? || column_vs_value[:dm_id_number].blank? || column_vs_value[:contents].blank?

              dm = DirectMessage.find_by(id_number: column_vs_value[:dm_id_number])
              dm_id = dm&.id

              # NOTE: dm&.user は不要としてもいい
              user = dm&.user || create_or_find_by_user(column_vs_value)
              user_id = user&.id

              unique_attrs = {
                id_on_sheet: column_vs_value[:id_on_sheet],
                user_id: user_id,
                vote_method: :by_direct_message,
                direct_message_id: dm_id,
                other_tweet_ids_text: nil,
                contents: column_vs_value[:contents]
              }

              # 「両部門の場合は、N列とO列に協力攻撃、P列Q列R列にオールキャラ部門を入力する」という例外規定
              case column_vs_value[:category]
              when '①オールキャラ部門'
                chara_1 = column_vs_value[:input_01]
                chara_2 = column_vs_value[:input_02]
                chara_3 = column_vs_value[:input_03]
              when '両部門'
                chara_1 = column_vs_value[:input_03]
                chara_2 = column_vs_value[:input_04]
                chara_3 = column_vs_value[:input_05]
              end

              mutable_attrs = {
                is_invisible: column_vs_value[:is_invisible].to_boolean,
                is_out_of_counting: column_vs_value[:is_out_of_counting].to_boolean,
                memo: column_vs_value[:memo],
                chara_1: chara_1,
                chara_2: chara_2,
                chara_3: chara_3
              }

              CountingAllCharacter.find_or_initialize_by(unique_attrs).update!(mutable_attrs)
            end

            puts "#{sheet_names[i]} is Done." # rubocop:disable Rails/Output
          end
        end
        # rubocop:enable Metrics/BlockLength

        '[DONE] Sheets::Counting::AllCharacters.import_via_dm'
      end

      # screen_name でユーザーを一意に特定するのははあまり良くない
      def self.create_or_find_by_user(column_vs_value)
        existing_user = User.find_by(screen_name: column_vs_value[:screen_name])

        if existing_user.blank?
          client = TwitterRestApi.client
          # ここで API を消費する
          user = client.user(column_vs_value[:screen_name])

          # NOTE: ユーザーが削除されていると User not found. (Twitter::Error::NotFound) が発生する
          # NOTE: その場合はシートのデータを修正する必要がある

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
