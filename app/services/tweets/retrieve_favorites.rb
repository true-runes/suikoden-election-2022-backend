# rubocop:disable Rails/Output
module Tweets
  class RetrieveFavorites
    MAX_LOOP_COUNT = 20
    INIT_NEXT_MAX_ID = 1

    def self.all(client = nil)
      client = TwitterRestApi.client(account_key: :sub_gensosenkyo) if client.nil?

      all_favorite_tweets = []
      api_request_base_options = { count: 200 }
      next_max_id = INIT_NEXT_MAX_ID

      # max_id は「その数以下」を示す（その数自身を含む）
      MAX_LOOP_COUNT.times do |i|
        options = api_request_base_options
        options.merge!({ max_id: next_max_id }) if next_max_id != INIT_NEXT_MAX_ID

        # API が消費される
        fav_tweets = client.favorites(options) # ツイートID 降順 の Array
        all_favorite_tweets << fav_tweets
        all_favorite_tweets.flatten!

        puts "[LOG] #{i + 1}回目 のループでの fav_tweets を取得しました。"
        puts "[LOG] #{fav_tweets.count}件 の fav_tweets を取得しました。"

        break if fav_tweets.empty?

        next_max_id = fav_tweets.last.id - 1
        puts "[LOG] next_max_id は #{next_max_id} です。"

        sleep 5
      end

      save_fav_tweets(all_favorite_tweets)
    end

    def self.continuous(client = nil)
      return 'SubGensosenkyoFav にレコードが存在しません' if SubGensosenkyoFav.first.nil?

      client = TwitterRestApi.client(account_key: :sub_gensosenkyo) if client.nil?

      all_favorite_tweets = []
      api_request_base_options = { count: 200 }
      next_since_id = SubGensosenkyoFav.order(id_number: :desc).first.id_number

      # since_id は「その数より大きい」を示す（その数自身は含まない）
      MAX_LOOP_COUNT.times do |i|
        options = api_request_base_options
        options.merge!({ since_id: next_since_id })

        # API が消費される
        fav_tweets = client.favorites(options) # ツイートID 降順 の Array
        all_favorite_tweets << fav_tweets
        all_favorite_tweets.flatten!

        puts "[LOG] #{i + 1}回目 のループでの fav_tweets を取得しました。"
        puts "[LOG] #{fav_tweets.count}件 の fav_tweets を取得しました。"

        break if fav_tweets.empty?

        next_since_id = fav_tweets.first.id
        puts "[LOG] next_since_id は #{next_since_id} です。"

        sleep 5
      end

      save_fav_tweets(all_favorite_tweets)
    end

    def self.save_fav_tweets(fav_tweets, model_name: 'SubGensosenkyoFav')
      return if model_name != 'SubGensosenkyoFav'

      ActiveRecord::Base.transaction do
        fav_tweets.each do |fav_tweet|
          next if SubGensosenkyoFav.exists?(id_number: fav_tweet.id)

          sub_gensosenkyo_fav = SubGensosenkyoFav.new(
            id_number: fav_tweet.id,
            tweet: Tweet.find_by(id_number: fav_tweet.id)
          )

          sub_gensosenkyo_fav.save!
        end
      end
    end
  end
end
# rubocop:enable Rails/Output
