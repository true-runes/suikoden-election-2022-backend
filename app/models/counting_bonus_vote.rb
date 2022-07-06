class CountingBonusVote < ApplicationRecord
  include CountingTools

  belongs_to :tweet, optional: true
  belongs_to :direct_message, optional: true
  belongs_to :user # 鍵でも User のレコードは取得できるので optional 指定は不要

  scope :invisible, -> { where(is_invisible: true) }
  scope :out_of_counting, -> { where(is_out_of_counting: true) }
  scope :valid_records, -> { where(is_out_of_counting: false).where(is_invisible: false) }
  scope :by_tweet, -> { where(vote_method: :by_tweet) }
  scope :by_dm, -> { where(vote_method: :by_direct_message) }

  enum vote_method: { by_tweet: 0, by_direct_message: 1, by_others: 99 }, _prefix: true
  enum bonus_category: {
    op_cl_illustrations: 0,
    short_stories: 1,
    result_illustrations: 2,
    fav_quotes: 3,
    sosenkyo_campaigns: 4
  }, _prefix: true

  def self.all_fav_quote_character_names_including_duplicated
    chara_columns = %i[chara_01 chara_02 chara_03 chara_04 chara_05 chara_06 chara_07 chara_08 chara_09 chara_10]
    character_names = []

    chara_columns.each do |column|
      character_names += CountingBonusVote.valid_records.where(bonus_category: :fav_quotes).pluck(column)
    end

    # TODO: compact_blank が使えるはず
    character_names.compact.reject(&:empty?).sort
  end

  def self.fav_quote_character_name_to_number_of_votes
    all_fav_quote_character_names_including_duplicated.tally.sort_by { |_, v| v }.reverse.to_h
  end

  def self.fav_quote_ranking_style
    Presenter::Counting.key_to_rank_number_by_sosenkyo_style(fav_quote_character_name_to_number_of_votes)
  end

  def short_stories_theme
    return 'そういえば' if tweet&.id_number == 1541078991146467329 # 例外的な処理

    return if bonus_category != 'short_stories'

    pickuped_theme_names = ['記念', 'そういえば', 'フリー', 'その他']

    # NOTE: 一般的な記述の中に「お題」の語句が含まれていると誤判定する
    this_theme = pickuped_theme_names.find do |theme|
      contents.include?(theme)
    end

    {
      'その他' => 'フリー'
    }[this_theme] || this_theme
  end
end
