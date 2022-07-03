class CountingAllCharacter < ApplicationRecord
  include CountingTools

  belongs_to :tweet, optional: true
  belongs_to :direct_message, optional: true
  belongs_to :user

  scope :invisible, -> { where(is_invisible: true) }
  scope :out_of_counting, -> { where(is_out_of_counting: true) }
  scope :valid_tweets, -> { where(is_out_of_counting: false).where(is_invisible: false) }

  enum vote_method: { by_tweet: 0, by_direct_message: 1, by_others: 99 }

  def self.tweets_whose_invisible_status_is_different_between_sheet_and_database
    sheet_invisible_tweet_ids = CountingAllCharacter.invisible.pluck(:tweet_id)

    result = []
    sheet_invisible_tweet_ids.each do |tweet_id|
      database_tweet = Tweet.find_by(id: tweet_id)

      result << CountingAllCharacter.find_by(tweet_id: tweet_id) if CountingAllCharacter.find_by(tweet_id: tweet_id).is_invisible == database_tweet.is_public
    end

    result
  end

  # キャラ1〜3は、AIがsuggestしたものに含まれるか否か？
  # キャラ名はキャラデータベースにあるものと一致しているか？
  # 同一人物の複数ツイートで複数計上していないか
  def self.tweeted_all_characters
    chara_1_column_characters = CountingAllCharacter.pluck(:chara_1)
    chara_2_column_characters = CountingAllCharacter.pluck(:chara_2)
    chara_3_column_characters = CountingAllCharacter.pluck(:chara_3)

    (chara_1_column_characters + chara_2_column_characters + chara_3_column_characters).uniq.compact.sort
  end

  def self.character_db_diff
    result = []

    tweeted_all_characters.each do |character|
      result << character if Character.where(name: character).blank?
    end

    result
  end

  # もとの行の内容が知りたい
  # どうだったらOKでどうだったらNGなのか？
  # キャラ計上数が4以上だとNG
  # other_tweetがvalid_tweetsでないならスルー
  def self.check_other_tweets
    result = []

    CountingAllCharacter.valid_tweets.other_tweets_exists.each do |c|
      c.other_tweets.each do |t|
        # tweet = Tweet.find_by(id: t.tweet_id)

        # result << tweet if tweet.is_public?

        result << t if !t.is_out_of_counting && !t.is_invisible?
      end
    end

    result
  end

  def other_tweets
    # CountingAllCharacter.where('other_tweet_ids_text like ?', '%|%')
    CountingAllCharacter.includes(:tweet).where(
      tweet:
        {
          id_number: other_tweet_ids_text.split(',')
        }
    )
  end
end
