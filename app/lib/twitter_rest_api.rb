class TwitterRestApi
  def self.client(consumer_key: nil, consumer_secret: nil, access_token: nil, access_secret: nil)
    Twitter::REST::Client.new do |config|
      config.consumer_key        = consumer_key || ENV.fetch('TWITTER_CONSUMER_KEY', nil)
      config.consumer_secret     = consumer_secret || ENV.fetch('TWITTER_CONSUMER_SECRET', nil)
      config.access_token        = access_token || ENV.fetch('TWITTER_ACCESS_TOKEN', nil)
      config.access_token_secret = access_secret || ENV.fetch('TWITTER_ACCESS_SECRET', nil)
    end
  end
end
