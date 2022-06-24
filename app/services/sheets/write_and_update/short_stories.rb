# ボーナス票・お題小説
module Sheets
  module WriteAndUpdate
    class ShortStories
      def self.exec
        # NOTE: for_api は中身が動的になってしまうので使ってはいけない
        tweets = Tweet.short_stories
        kakikomi_data = []

        tweets.each_with_index do |tweet, i|
          tmp_data = {}

          # 対応表があるとこのハッシュが活きそう
          tmp_data['tweet_id'] = tweet.id_number
          tmp_data['url'] = tweet.url
          tmp_data['tweeted_at'] = tweet.tweeted_at.strftime('%Y/%m/%d %H:%M:%S')
          tmp_data['full_text'] = tweet.full_text
          tmp_data['is_public'] = tweet.is_public # ここが冪等ではない
          tmp_data['suggested_names'] = NaturalLanguage::SuggestCharacterNames.exec(tweet) # Array この行のコストが高いので、分離したい

          kakikomi_data << tmp_data
        end

        # 行全体を示す範囲は An:GRn になる
        # データの入力規則は $AX1:$GR1 になる

        final_kakikomi_data = []
        kakikomi_data.each do |data|
          tmp = []

          tmp[0] = nil # id_on_sheet はそのまま
          tmp[1] = data['tweet_id'].to_s # to_s にしないと数値型になってしまって丸まってしまう
          tmp[2] = data['tweeted_at'].to_s # to_s にしないと日付型になる
          tmp[3] = data['url']
          tmp[4] = data['is_public']
          # 5は備考、6は要レビュー？、7は二次チェック済み？、8は全チェック終了？、9はふぁぼ済み？ となる
          tmp[10] = data['full_text'] # 11列目 (K)
          tmp[49] = data['suggested_names'] # 50列目 (AX)
          tmp[199] = '' # 200列目 (GR) を表示させるために空文字を入れる

          tmp.flatten! # suggested_names は長さが不定なので flatten する

          final_kakikomi_data << tmp
        end

        # 入力キャラ候補は長さが不定なので特定列以降に書き込む
        SheetData.write_rows(
          sheet_id: ENV.fetch('COUNTING_BONUS_SHORT_STORIES_SHEET_ID', nil),
          range: 'ツイート!A2', # 始点を A1 形式で入れる（そういう決まり）
          # nil を与えると無視される（空文字での上書きはされない）
          values: final_kakikomi_data
        )
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
# 送信者は まとめて name (@screen_name) でも、DMはいいかも
# というか、一般集計は人名関係ないからそもそも入れてなかった

# tweets = Tweet.gensosenkyo_2022_votes
# tweets.each_slice(100).with_index do |tweets_100, index|
#   # ここで処理メソッドに tweets_100 と index から導き出されたシート名を渡せば良さそう
# end

# index_number_vs_sheet_name = {
#  0 => '集計_01',
#  1 => '集計_02',

# case i
# when 0..99

# end

# iが
# 0-99なら集計_01
# 100-199なら集計_02
# 200-299なら集計_03
# (100 * (N - 1)) <= i <= ((100 * N) - 1) ならば "集計_ゼロパディングN"

# ns = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] # (1..30).to_a
# ns.each do |n|
#   # 0 <= i <= 99 で比較し…
#   # 100 <= i <= 199 で比較し…
#   if 100 * (n - 1) <= i && i <= (100 * n) - 1
#     sheet = "集計_0#{n}"
#     # Write to spreadsheet
#   end
# end
