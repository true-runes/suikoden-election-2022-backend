# ボーナス票・お題小説
module Sheets
  module WriteAndUpdate
    class ShortStories
      def self.exec
        # NOTE: for_api は中身が動的になってしまうので使ってはいけない
        tweets = Tweet.short_stories

        tweets.each_slice(100).with_index do |tweets_100, index_on_hundred|
          prepared_written_data_by_array_in_hash = []

          tweets_100.each_with_index do |tweet, i|
            inserted_hash = {}

            user = tweet.user
            by_user_other_tweets = tweets.where(user: user).where.not(id: tweet.id)
            # カンマ区切りにすると to_s しても数値に変換されてしまう
            by_user_other_tweets_for_sheet = by_user_other_tweets.map { |t| t.id_number.to_s }.join(' | ').to_s

            inserted_hash['screen_name'] = tweet.user.screen_name
            inserted_hash['tweet_id'] = tweet.id_number.to_s
            inserted_hash['日時'] = tweet.tweeted_at.strftime('%Y/%m/%d %H:%M:%S').to_s
            inserted_hash['URL'] = tweet.url
            inserted_hash['ツイ見られない？'] = !tweet.is_public
            inserted_hash['別ツイ'] = by_user_other_tweets_for_sheet.to_s || ''
            inserted_hash['ふぁぼ済？'] = false
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

            # TODO: 取得漏れには 10001 始まりを付与したい
            id_on_sheet = (index_on_hundred * 100) + (index + 1)

            # TODO: ハードコーディングをしたくない
            row[0] = id_on_sheet
            row[1] = written_data_hash['screen_name']
            row[2] = written_data_hash['tweet_id']
            row[3] = written_data_hash['日時']
            row[4] = written_data_hash['URL']
            row[5] = written_data_hash['別ツイ']
            row[7] = written_data_hash['ツイ見られない？']
            row[9] = written_data_hash['ふぁぼ済？']
            row[10] = written_data_hash['二次チェック済？']
            row[11] = written_data_hash['内容']
            row[49] = written_data_hash['suggested_names'] # 50列目 (AX)
            row[199] = '' # 200列目 (GR) を表示させるために空文字を入れる

            row.flatten! # suggested_names は長さが不定なので flatten する

            written_data << row
          end

          # suggested_names を最初に全削除する
          SheetData.write_rows(
            sheet_id: ENV.fetch('COUNTING_BONUS_SHORT_STORIES_SHEET_ID', nil),
            range: "#{sheet_name}!AX2:GR101",
            values: [[''] * 50] * 100 # 100行分の空文字を入れる
          )

          SheetData.write_rows(
            sheet_id: ENV.fetch('COUNTING_BONUS_SHORT_STORIES_SHEET_ID', nil),
            range: "#{sheet_name}!A2", # 始点
            values: written_data
          )
        end
      end
    end
  end
end
