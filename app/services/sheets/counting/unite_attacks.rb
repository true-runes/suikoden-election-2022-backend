module Sheets
  module Counting
    class UniteAttacks
      def self.import_via_tweet
        sheet_names = YAML.load_file(Rails.root.join('config/counting_sheet_names.yml'))['names']

        ActiveRecord::Base.transaction do
          sheet_names.each_with_index do |sheet_name, i|
            rows = SheetData.get_rows(sheet_id: ENV.fetch('COUNTING_UNITE_ATTACKS_SHEET_ID', nil), range: "#{sheet_names[i]}!A2:Q101")

            rows.each do |row|
              # TODO: 設定ファイルを用いてスマートに定義したい
              column_vs_value = {
                id_on_sheet: row[0],
                tweet_id_number: row[2],
                other_tweet_ids_text: row[5],
                is_invisible: row[7], # "FALSE" のような文字列なので注意
                is_out_of_counting: row[8], # "FALSE" のような文字列なので注意
                contents: row[11],
                memo: row[12],
                product_name: row[14],
                unite_attack_name: row[15]
              }

              next if column_vs_value[:id_on_sheet].blank? || column_vs_value[:tweet_id_number].blank? || column_vs_value[:contents].blank?

              tweet = Tweet.find_by(id_number: column_vs_value[:tweet_id_number])
              tweet_id = tweet.id
              user_id = tweet.user.id

              unique_attrs = {
                id_on_sheet: column_vs_value[:id_on_sheet],
                user_id: user_id,
                vote_method: :by_tweet,
                tweet_id: tweet_id,
                contents: column_vs_value[:contents],
                memo: column_vs_value[:memo]
              }

              mutable_attrs = {
                # 123456,654321,777777 のような文字列になる
                other_tweet_ids_text: column_vs_value[:other_tweet_ids_text].split('|').map(&:strip).join(','),
                is_invisible: column_vs_value[:is_invisible].to_boolean,
                is_out_of_counting: column_vs_value[:is_out_of_counting].to_boolean,
                product_name: column_vs_value[:product_name],
                unite_attack_name: column_vs_value[:unite_attack_name]
              }

              CountingUniteAttack.find_or_initialize_by(unique_attrs).update!(mutable_attrs)
            end
          end
        end

        '[DONE] Sheets::Counting::UniteAttacks.import_via_tweet'
      end

      def self.import_via_dm
        sheet_names = YAML.load_file(Rails.root.join('config/counting_sheet_names.yml'))['names']

        ActiveRecord::Base.transaction do
          sheet_names.each_with_index do |sheet_name, i|
            rows = SheetData.get_rows(sheet_id: ENV.fetch('COUNTING_DIRECT_MESSAGES_SHEET_ID', nil), range: "#{sheet_names[i]}!A2:Q101")

            rows.each do |row|
              # TODO: 設定ファイルを用いてスマートに定義したい
              column_vs_value = {
                id_on_sheet: row[0],
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
                input_10: row[22],
              }

              next if column_vs_value[:category] != '②協力攻撃部門' || column_vs_value[:category] != '両部門'

              next if column_vs_value[:id_on_sheet].blank? || column_vs_value[:dm_id_number].blank? || column_vs_value[:contents].blank?

              dm = DirectMessage.find_by(id_number: column_vs_value[:dm_id_number])
              dm_id = dm.id
              user_id = dm.user.id

              unique_attrs = {
                id_on_sheet: column_vs_value[:id_on_sheet],
                user_id: user_id,
                vote_method: :by_direct_message,
                direct_message_id: dm_id,
                other_tweet_ids_text: nil,
                contents: column_vs_value[:contents],
                memo: column_vs_value[:memo]
              }

              # 「両部門の場合は、N列とO列に協力攻撃、P列Q列R列にオールキャラ部門を入力する」という例外規定
              mutable_attrs = {
                is_invisible: column_vs_value[:is_invisible].to_boolean,
                is_out_of_counting: column_vs_value[:is_out_of_counting].to_boolean,
                product_name: column_vs_value[:input_01],
                unite_attack_name: column_vs_value[:input_02]
              }

              CountingUniteAttack.find_or_initialize_by(unique_attrs).update!(mutable_attrs)
            end
          end
        end

        '[DONE] Sheets::Counting::UniteAttacks.import_via_dm'
      end
    end
  end
end
