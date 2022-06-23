class TwitterRestApi
  # account_key は シンボル で指定する
  def self.client(account_key: :ayy)
    credentials = convert_account_key_to_credentials(account_key)
    return if credentials.nil?

    Twitter::REST::Client.new do |config|
      config.consumer_key        = credentials[:consumer_key]
      config.consumer_secret     = credentials[:consumer_secret]
      config.access_token        = credentials[:access_token]
      config.access_token_secret = credentials[:access_token_secret]
    end
  end

  def self.convert_account_key_to_credentials(account_key)
    {
      gensosenkyo: {
        consumer_key: ENV.fetch('TWITTER_CONSUMER_KEY_GENSOSENKYO', nil),
        consumer_secret: ENV.fetch('TWITTER_CONSUMER_SECRET_GENSOSENKYO', nil),
        access_token: ENV.fetch('TWITTER_ACCESS_TOKEN_GENSOSENKYO', nil),
        access_token_secret: ENV.fetch('TWITTER_ACCESS_SECRET_GENSOSENKYO', nil)
      },
      sub_gensosenkyo: {
        consumer_key: ENV.fetch('TWITTER_CONSUMER_KEY_SUB_GENSOSENKYO', nil),
        consumer_secret: ENV.fetch('TWITTER_CONSUMER_SECRET_SUB_GENSOSENKYO', nil),
        access_token: ENV.fetch('TWITTER_ACCESS_TOKEN_SUB_GENSOSENKYO', nil),
        access_token_secret: ENV.fetch('TWITTER_ACCESS_SECRET_SUB_GENSOSENKYO', nil)
      },
      tmytn: {
        consumer_key: ENV.fetch('TWITTER_CONSUMER_KEY_TMYTN', nil),
        consumer_secret: ENV.fetch('TWITTER_CONSUMER_SECRET_TMYTN', nil),
        access_token: ENV.fetch('TWITTER_ACCESS_TOKEN_TMYTN', nil),
        access_token_secret: ENV.fetch('TWITTER_ACCESS_SECRET_TMYTN', nil)
      },
      tmychan: {
        consumer_key: ENV.fetch('TWITTER_CONSUMER_KEY_TMYCHAN', nil),
        consumer_secret: ENV.fetch('TWITTER_CONSUMER_SECRET_TMYCHAN', nil),
        access_token: ENV.fetch('TWITTER_ACCESS_TOKEN_TMYCHAN', nil),
        access_token_secret: ENV.fetch('TWITTER_ACCESS_SECRET_TMYCHAN', nil)
      },
      ayy: {
        consumer_key: ENV.fetch('TWITTER_CONSUMER_KEY_AYY', nil),
        consumer_secret: ENV.fetch('TWITTER_CONSUMER_SECRET_AYY', nil),
        access_token: ENV.fetch('TWITTER_ACCESS_TOKEN_AYY', nil),
        access_token_secret: ENV.fetch('TWITTER_ACCESS_SECRET_AYY', nil)
      }
    }[account_key]
  end
end
