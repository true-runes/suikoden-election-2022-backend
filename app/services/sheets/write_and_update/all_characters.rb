module Sheets
  module WriteAndUpdate
    class AllCharacters
      # 列情報は clasp/gensosenkyo/ZzzColumnNames.ts を参考にする
      def self.exec
        # NOTE: for_api だと突然削除や不可視にした人がいたらレコード順がズレて死亡なのでやらないこと
        tweets = Tweet.gensosenkyo_2022_votes.valid_term_votes

        tweets.each_slice(100).with_index do |tweets_100, index_on_hundred|
          prepared_written_data_by_array_in_hash = []

          tweets_100.each_with_index do |tweet, i|
            inserted_hash = {}

            user = tweet.user
            by_user_other_tweets = tweets.where(user: user).where.not(id: tweet.id)
            by_user_other_tweets_for_sheet = by_user_other_tweets.map { |t| t.id_number.to_s }.join(',').to_s

            inserted_hash['screen_name'] = tweet.user.screen_name
            inserted_hash['tweet_id'] = tweet.id_number.to_s
            inserted_hash['日時'] = tweet.tweeted_at.strftime('%Y/%m/%d %H:%M:%S').to_s
            inserted_hash['URL'] = tweet.url
            inserted_hash['ツイートが見られない？'] = !tweet.is_public
            inserted_hash['別ツイート'] = by_user_other_tweets_for_sheet || ''
            inserted_hash['ふぁぼ済？'] = true # to_s がいるかも
            inserted_hash['内容'] = tweet.full_text
            # この行のコストが高い
            inserted_hash['suggested_names'] = NaturalLanguage::SuggestCharacterNames.exec(tweet) # Array

            prepared_written_data_by_array_in_hash << inserted_hash
          end

          two_digit_number = format('%02<number>d', number: index_on_hundred + 1)
          sheet_name = "集計_#{two_digit_number}"

          written_data = []

          prepared_written_data_by_array_in_hash.each_with_index do |written_data_hash, index|
            row = []

            id_on_sheet = (index_on_hundred * 100) + (index + 1)

            row[0] = id_on_sheet
            row[1] = written_data_hash['screen_name']
            row[2] = written_data_hash['tweet_id']
            row[3] = written_data_hash['日時']
            row[4] = written_data_hash['URL']
            row[5] = written_data_hash['ツイートが見られない？']
            row[8] = written_data_hash['別ツイート']
            row[9] = written_data_hash['ふぁぼ済？']
            row[10] = written_data_hash['二次チェック済？']
            row[11] = written_data_hash['内容']
            row[49] = written_data_hash['suggested_names'] # 50列目 (AX)
            row[199] = '' # 200列目 (GR) を表示させるために空文字を入れる

            row.flatten! # suggested_names は長さが不定なので flatten する

            written_data << row
          end

          SheetData.write_rows(
            sheet_id: ENV.fetch('COUNTING_BONUS_SHORT_STORIES_SHEET_ID', nil),
            range: "#{sheet_name}!A2", # 始点を A1 形式で入れる（そういう決まり）
            values: written_data
          )
        end
      end
    end
  end
end

# DM
# dms = DirectMessage.to_gensosenkyo
# dm = dms.first
# dm.messaged_at
# dm.content_text
# dm.user.screen_name
# dm.user.name
# id（自動）	送信者（自動）	内容（自動）	キャラ1	キャラ2	キャラ3	ツイートが見られる？（自動）	備考	要レビュー？	返信 or チェック済み？	全チェック終了？	ドロップダウン用配列（触らない）
# DM は言語が取得できない
