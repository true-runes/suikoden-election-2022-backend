class CheckVisibleAndInvisibleTweetIdNumbers
  INTERVAL_SECONDS = 5

  def self.exec(tweet_id_numbers, client_account_key: :ayy)
    client = TwitterRestApi.client(account_key: client_account_key)

    all_invisible_tweet_id_numbers = []

    # 不可視の場合には client.statuses([tweet_id_number, ...]) の戻り値に返ってこない仕様を利用する
    tweet_id_numbers.each_slice(100) do |this_tweet_id_numbers|
      visible_tweet_objects = client.statuses(this_tweet_id_numbers) # API が消費される
      visible_tweet_id_numbers = visible_tweet_objects.map(&:id) # #id により id_number を取得できる

      # 配列 から 配列 を引き算して、不可視のツイートの id_number を取り出す
      invisible_tweet_id_numbers = this_tweet_id_numbers - visible_tweet_id_numbers

      all_invisible_tweet_id_numbers << invisible_tweet_id_numbers
      all_invisible_tweet_id_numbers.flatten!

      sleep INTERVAL_SECONDS
    end

    all_visible_tweet_id_numbers = Tweet.all.map(&:id_number) - all_invisible_tweet_id_numbers

    { visible: all_visible_tweet_id_numbers, invisible: all_invisible_tweet_id_numbers}
  end
end
