class CountingAllCharacter < ApplicationRecord
  include CountingTools

  belongs_to :tweet, optional: true
  belongs_to :direct_message, optional: true
  belongs_to :user # 鍵でも User のレコードは取得できるので optional 指定は不要

  scope :invisible, -> { where(is_invisible: true) }
  scope :out_of_counting, -> { where(is_out_of_counting: true) }
  scope :valid_records, -> { where(is_out_of_counting: false).where(is_invisible: false) }
  scope :by_tweet, -> { where(vote_method: :by_tweet) }
  scope :by_dm, -> { where(vote_method: :by_direct_message) }

  enum vote_method: { by_tweet: 0, by_direct_message: 1, op_cl_illustrations_bonus: 2, by_others: 99 }, _prefix: true

  def self.tweets_whose_invisible_status_is_different_between_sheet_and_database
    sheet_invisible_tweet_ids = CountingAllCharacter.invisible.pluck(:tweet_id)

    result = []
    sheet_invisible_tweet_ids.each do |tweet_id|
      database_tweet = Tweet.find_by(id: tweet_id)

      result << CountingAllCharacter.find_by(tweet_id: tweet_id) if CountingAllCharacter.find_by(tweet_id: tweet_id).is_invisible == database_tweet.is_public
    end

    result
  end

  # キャラの数え上げには SQL を使わずに個数を愚直に数える方法を採る
  def self.all_character_names_including_duplicated
    # オールキャラではさらに統合集計が必要なので「ボ・OP・CLイラスト（協力攻撃）」は除外している
    chara_1_column_characters = CountingAllCharacter.valid_records.where.not(vote_method: :op_cl_illustrations_bonus).pluck(:chara_1)
    chara_2_column_characters = CountingAllCharacter.valid_records.where.not(vote_method: :op_cl_illustrations_bonus).pluck(:chara_2)
    chara_3_column_characters = CountingAllCharacter.valid_records.where.not(vote_method: :op_cl_illustrations_bonus).pluck(:chara_3)

    (chara_1_column_characters + chara_2_column_characters + chara_3_column_characters).compact_blank.sort
  end

  def self.ranking
    # Enumerable#tally は、配列の要素をキーとして、その要素の個数を値としてハッシュに格納する
    base_ranking = all_character_names_including_duplicated.tally.sort_by { |_, v| v }.reverse.to_h

    ranking_to_array = base_ranking.to_a
    current_rank = 1
    ranking = []

    ranking_to_array.each_with_index do |(name, number_of_votes), index|
      tmp_hash = {}
      tmp_hash[:name] = name
      tmp_hash[:number_of_votes] = number_of_votes

      if index == 0
        tmp_hash[:rank] = current_rank
      else
        previous_number_of_votes = ranking_to_array[index - 1][1]

        if number_of_votes == previous_number_of_votes
          tmp_hash[:rank] = current_rank
        else
          tmp_hash[:rank] = current_rank + 1

          current_rank += 1
        end
      end

      ranking << tmp_hash
    end

    # exist_same_rank キーとその値 (Boolean) を追加する
    ranking.each_with_index do |rank_item, index|
      rank_item[:exist_same_rank] = case index
                                    when 0
        rank_item[:rank] == ranking[index + 1][:rank]
                                    when ranking.size - 1
        rank_item[:rank] == ranking[index - 1][:rank]
                                    else
        rank_item[:rank] == ranking[index - 1][:rank] || rank_item[:rank] == ranking[index + 1][:rank]
                            end
    end

    # products キーとその値を追加する
    ranking.each do |rank_item|
      rank_item[:products] = Character.find_by(name: rank_item[:name])&.products
    end

    ranking.sort_by { |element| [element[:rank], element[:name]] }
  end

  def self.character_names_which_not_exist_in_character_db
    result = []

    all_character_names_including_duplicated.uniq.each do |character|
      result << character if Character.where(name: character).blank?
    end

    result
  end

  # 引数の character_names のうちのどれか一つのキャラ名がそのレコードに含まれているかどうか
  def includes_either_character_name?(*character_names)
    character_names_on_record = three_chara_names.compact_blank

    return false if character_names_on_record.blank?

    character_names.any? do |character_name|
      character_name.in?(character_names_on_record)
    end
  end

  # 引数の character_names の全てのキャラ名がそのレコードに含まれているかどうか
  def includes_all_character_names?(*character_names)
    character_names_on_record = three_chara_names.compact_blank

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

  # 「AI のサジェスト」と「開票のキャラ名」の一致結果がどうだったかのデータを返す
  def suggestion_result
    character_names = three_chara_names.compact_blank
    suggested_names = NaturalLanguage::SuggestCharacterNames.exec(contents_resource)

    suggestion_success_names = []
    suggestion_failed_names = []

    character_names.each do |character_name|
      if character_name.in?(suggested_names)
        suggestion_success_names << character_name
      else
        suggestion_failed_names << character_name
      end
    end

    {
      character_names_count: character_names.size,
      success: suggestion_success_names,
      failure: suggestion_failed_names,
      is_all_success: suggestion_success_names.size == character_names.size && character_names.size.positive?
    }
  end

  def contents_resource
    case vote_method
    when 'by_tweet'
      tweet
    when 'by_direct_message'
      direct_message
    end
  end
end
