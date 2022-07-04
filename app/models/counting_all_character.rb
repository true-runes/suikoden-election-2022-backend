class CountingAllCharacter < ApplicationRecord
  include CountingTools

  belongs_to :tweet, optional: true
  belongs_to :direct_message, optional: true
  belongs_to :user # 鍵でも User のレコードは取得できるので optional 指定は不要

  scope :invisible, -> { where(is_invisible: true) }
  scope :out_of_counting, -> { where(is_out_of_counting: true) }
  scope :valid_records, -> { where(is_out_of_counting: false).where(is_invisible: false) }

  enum vote_method: { by_tweet: 0, by_direct_message: 1, by_others: 99 }, _prefix: true

  def self.tweets_whose_invisible_status_is_different_between_sheet_and_database
    sheet_invisible_tweet_ids = CountingAllCharacter.invisible.pluck(:tweet_id)

    result = []
    sheet_invisible_tweet_ids.each do |tweet_id|
      database_tweet = Tweet.find_by(id: tweet_id)

      result << CountingAllCharacter.find_by(tweet_id: tweet_id) if CountingAllCharacter.find_by(tweet_id: tweet_id).is_invisible == database_tweet.is_public
    end

    result
  end

  def self.all_character_names_including_duplicated
    chara_1_column_characters = CountingAllCharacter.valid_records.pluck(:chara_1)
    chara_2_column_characters = CountingAllCharacter.valid_records.pluck(:chara_2)
    chara_3_column_characters = CountingAllCharacter.valid_records.pluck(:chara_3)

    # 空文字は削除する
    (chara_1_column_characters + chara_2_column_characters + chara_3_column_characters).compact.reject(&:empty?).sort
  end

  def self.character_name_to_number_of_votes
    all_character_names_including_duplicated.tally.sort_by { |_, v| v }.reverse.to_h
  end

  def self.character_names_which_dont_exist_in_character_db
    result = []

    all_character_names_including_duplicated.uniq.each do |character|
      result << character if Character.where(name: character).blank?
    end

    result
  end

  # character_names のうちのどれか一つのキャラ名が含まれているかどうか
  def includes_either_character_name?(*character_names)
    character_names_on_record = [chara_1, chara_2, chara_3].compact.reject(&:empty?)

    return false if character_names_on_record.blank?

    character_names.any? do |character_name|
      character_name.in?(character_names_on_record)
    end
  end

  # character_names の全てのキャラ名が含まれているかどうか
  def includes_all_character_names?(*character_names)
    character_names_on_record = [chara_1, chara_2, chara_3].compact.reject(&:empty?)

    return false if character_names_on_record.blank?

    character_names.all? do |character_name|
      character_name.in?(character_names_on_record)
    end
  end

  def other_tweets
    return if vote_method_by_direct_message?

    CountingAllCharacter.includes(:tweet).where(
      tweet: { id_number: other_tweet_ids_text.split(',') }
    )
  end

  # FIXME: このメソッドは使用していない
  def self.check_other_tweets
    result = []

    CountingAllCharacter.valid_records.other_tweets_exists.each do |c|
      c.other_tweets.each do |t|
        # tweet = Tweet.find_by(id: t.tweet_id)

        # result << tweet if tweet.is_public?

        result << t if !t.is_out_of_counting && !t.is_invisible?
      end
    end

    result
  end
end
