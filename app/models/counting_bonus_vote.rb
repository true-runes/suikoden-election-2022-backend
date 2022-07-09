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
    op_cl_illustrations: 0, # 未使用
    short_stories: 1,
    result_illustrations: 2, # 未使用
    fav_quotes: 3,
    sosenkyo_campaigns: 4
  }, _prefix: true

  # category_name は書き込み対象のシートを指している（名前が良くないので変えるべき）
  # 書き込み対象のシートによって何を書き込むかが異なるので、base_records がいろいろ変わる
  # base_records のソースが必ずしも CountingBonusVote のレコードであるとは限らない
  def self.ranking(written_sheet_name) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return unless written_sheet_name.in?(
      [
        'ボ・お題小説',
        'ボ・推し台詞',
        'ボ・開票イラスト',
        'ボ・選挙運動',
        'ボ・OP・CLイラスト（オールキャラ）',
      ]
    )

    if written_sheet_name.in?(['ボ・お題小説'])
      base_records = CountingBonusVote.valid_records.where(bonus_category: :short_stories)

      ret_array = []

      base_records.each do |record|
        theme = record.short_stories_theme

        chara_names = []
        chara_names << record.chara_01
        chara_names << record.chara_02
        chara_names << record.chara_03
        chara_names << record.chara_04
        chara_names << record.chara_05
        chara_names << record.chara_06
        chara_names << record.chara_07
        chara_names << record.chara_08
        chara_names << record.chara_09
        chara_names << record.chara_10

        # FIXME: 複数人いた場合の処理
        ret_array << { theme: theme, chara_names: chara_names.compact_blank.sort.reject { |el| el == "FALSE"} }
      end

      return ret_array
    end

    if written_sheet_name.in?(['ボ・推し台詞'])
      chara_columns = %i[chara_01 chara_02 chara_03 chara_04 chara_05 chara_06 chara_07 chara_08 chara_09 chara_10]
      character_names = []

      # FIXME: 複数人いた場合の処理
      chara_columns.each do |column|
        character_names += CountingBonusVote.valid_records.where(bonus_category: :fav_quotes).pluck(column)
      end

      return character_names.compact_blank.sort.reject { |el| el == "FALSE"}
    end

    if written_sheet_name.in?(['ボ・開票イラスト'])
      result_array = []
      records = OnRawSheetResultIllustrationTotalling.all.reject { |record| record.character_name_by_sheet_totalling.start_with?('TEMP_') }

      records.each do |record|
        temp_hash = {}

        temp_hash[:name] = record.character_name_by_sheet_totalling
        temp_hash[:number_of_applications] = record.number_of_applications

        result_array << temp_hash
      end

      return result_array.sort_by { |element| [element[:name], element[:number_of_applications]] }
    end

    if written_sheet_name.in?(['ボ・選挙運動'])
      chara_columns = %i[chara_01 chara_02 chara_03 chara_04 chara_05 chara_06 chara_07 chara_08 chara_09 chara_10]
      character_names = []

      chara_columns.each do |column|
        character_names += CountingBonusVote.valid_records.where(bonus_category: :sosenkyo_campaigns).pluck(column)
      end

      return character_names.compact_blank.sort.reject { |el| el == "FALSE"}
    end

    if written_sheet_name.in?(['ボ・OP・CLイラスト（オールキャラ）'])
      result_array_all_characters = []
      records = CountingAllCharacter.where(vote_method: :op_cl_illustrations_bonus)
      records.each do |record|
        temp_hash = {}

        temp_hash[:chara_1] = record.chara_1

        result_array_all_characters << temp_hash
      end

      result_array_unite_attacks = []
      records = CountingUniteAttack.where(vote_method: :op_cl_illustrations_bonus)
      records.each do |record|
        temp_hash = {}

        temp_hash[:product_name] = record.product_name
        temp_hash[:unite_attack_name] = record.unite_attack_name

        result_array_unite_attacks << temp_hash
      end

      {
        all_characters: result_array_all_characters,
        unite_attacks: result_array_unite_attacks
      }
    end
  end

  # 「推し台詞」
  def self.all_fav_quote_character_names_including_duplicated
    chara_columns = %i[chara_01 chara_02 chara_03 chara_04 chara_05 chara_06 chara_07 chara_08 chara_09 chara_10]
    character_names = []

    chara_columns.each do |column|
      character_names += CountingBonusVote.valid_records.where(bonus_category: :fav_quotes).pluck(column)
    end

    character_names.compact_blank.sort
  end

  def self.fav_quote_character_name_to_number_of_votes
    all_fav_quote_character_names_including_duplicated.tally.sort_by { |_, v| v }.reverse.to_h
  end

  def self.fav_quote_ranking_style
    Presenter::Counting.key_to_rank_number_by_sosenkyo_style(fav_quote_character_name_to_number_of_votes)
  end

  # 「お題小説」
  def short_stories_theme
    return 'そういえば' if tweet&.id_number == 1541078991146467329 # 例外的な処理

    return if bonus_category != 'short_stories'

    pickuped_theme_names = ['記念', 'そういえば', 'フリー', 'その他']

    # NOTE: 一般的な記述の中に「お題」の語句が含まれていると誤判定してしまうので注意する
    this_theme = pickuped_theme_names.find do |theme|
      contents.include?(theme)
    end

    {
      'その他' => 'フリー'
    }[this_theme] || this_theme
  end
end
