class CountingUniteAttack < ApplicationRecord
  include CountingTools

  belongs_to :tweet, optional: true
  belongs_to :direct_message, optional: true
  belongs_to :user # 鍵でも User のレコードは取得できるので optional 指定は不要

  scope :invisible, -> { where(is_invisible: true) }
  scope :out_of_counting, -> { where(is_out_of_counting: true) }
  scope :no_data, -> { where(product_name: [nil, '']).where(unite_attack_name: [nil, '']) }
  scope :valid_records, lambda {
    where(is_invisible: false)
      .where(is_out_of_counting: false)
      .where.not(product_name: [nil, ''])
      .where.not(unite_attack_name: [nil, ''])
  }
  scope :by_tweet, -> { where(vote_method: :by_tweet) }
  scope :by_dm, -> { where(vote_method: :by_direct_message) }

  enum vote_method: { by_tweet: 0, by_direct_message: 1, by_others: 99 }, _prefix: true

  def self.full_ranking
    group(:product_name, :unite_attack_name).having('unite_attack_name is not null').order('count_all desc').count
  end

  def self.product_name_ranking
    group(:product_name).having('product_name is not null').order('count_all desc').count
  end

  # 不正レコードのチェッカ
  def self.invalid_records_whose_product_name_is_incorrect
    correct_product_names = NaturalLanguage::SuggestUniteAttackNames.title_names

    invalid_records = []

    valid_records.each do |record|
      invalid_records << record unless record.product_name.in?(correct_product_names)
    end

    invalid_records
  end

  # 不正レコードのチェッカ
  def self.invalid_records_whose_attack_name_is_incorrect
    # TODO: compact_blank が使えるはず
    correct_attack_names = OnRawSheetUniteAttack.pluck(:name, :name_en).flatten.reject(&:empty?)

    invalid_records = []

    valid_records.each do |record|
      invalid_records << record unless record.unite_attack_name.in?(correct_attack_names)
    end

    invalid_records
  end

  # 'English' というかは 'Not Japanese' であるのだが、便宜上 'English' とする
  def self.english_records
    includes(:tweet).valid_records.where.not(tweet: { language: 'ja' })
  end
end
