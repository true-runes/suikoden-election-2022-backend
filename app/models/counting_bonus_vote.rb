class CountingBonusVote < ApplicationRecord
  include CountingTools

  belongs_to :tweet, optional: true
  belongs_to :direct_message, optional: true
  belongs_to :user # 鍵でも User のレコードは取得できるので optional 指定は不要

  scope :invisible, -> { where(is_invisible: true) }
  scope :out_of_counting, -> { where(is_out_of_counting: true) }
  scope :valid_records, -> { where(is_out_of_counting: false).where(is_invisible: false) }

  enum vote_method: { by_tweet: 0, by_direct_message: 1, by_others: 99 }
  enum bonus_category: {
    op_cl_illustrations: 0,
    short_stories: 1,
    result_illustrations: 2,
    fav_quotes: 3,
    sosenkyo_campaigns: 4
  }

  def theme_on_short_story
    # TODO: contents に「お題」が含まれている場合は、そのお題を返す
  end
end
