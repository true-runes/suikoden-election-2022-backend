class BySearchWordTweet < TweetOnTweetStorage
  validates :search_word, presence: true
end
