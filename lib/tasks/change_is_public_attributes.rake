namespace :change_is_public_attributes do
  desc 'ツイートが非公開または削除になっていないかを調べ、変更があれば UPDATE を実行する'
  task all: :environment do
    # NOTE: この tweets の取り方をしているのでツイートが増えることによる実行タイムアウトに注意する
    tweets = Tweet.all
    tweet_id_numbers = tweets.map(&:id_number)

    # Twitter の REST API が消費されるので注意する
    visible_and_invisible_tweet_id_numbers = CheckVisibleAndInvisibleTweetIdNumbers.exec(tweet_id_numbers)

    visible_tweet_id_numbers = visible_and_invisible_tweet_id_numbers[:visible]
    invisible_tweet_id_numbers = visible_and_invisible_tweet_id_numbers[:invisible]

    ActiveRecord::Base.transaction do
      # 鍵ツイート => 公開ツイート の場合
      Tweet.where(id_number: visible_tweet_id_numbers).each do |tweet|
        tweet.update!(is_public: true) unless tweet.public?
      end

      # 公開ツイート => 鍵ツイート or 削除ツイート の場合
      Tweet.where(id_number: invisible_tweet_id_numbers).each do |tweet|
        tweet.update!(is_public: false) if tweet.public?
      end
    end

    puts '[DONE] check_tweet_is_invisible:exec'
  end
end
