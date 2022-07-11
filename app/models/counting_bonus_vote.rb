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

  def self.ranking_short_stories
    base_records = CountingBonusVote.valid_records.where(bonus_category: :short_stories)

    ranking_records = []

    base_records.each do |record|
      url = record.tweet.blank? ? '' : record.tweet.url
      id_on_sheet = record.id_on_sheet
      vote_method = record.vote_method
      theme = record.short_stories_theme
      contents = record.contents
      chara_names = [
        record.chara_01, record.chara_02, record.chara_03, record.chara_04,
        record.chara_05, record.chara_06, record.chara_07, record.chara_08,
        record.chara_09, record.chara_10
      ].compact_blank.sort.reject { |el| el == "FALSE"}

      chara_names.each do |chara_name|
        ranking_records << {
          url: url,
          id_on_sheet: id_on_sheet,
          vote_method: vote_method,
          theme: theme,
          contents: contents,
          character_name: chara_name
        }
      end
    end

    ranking_records.sort_by do |element|
      [element[:character_name]]
    end
  end

  def self.ranking_fav_quotes
    base_records = CountingBonusVote.valid_records.where(bonus_category: :fav_quotes)
    chara_columns = %i[
      chara_01 chara_02 chara_03 chara_04 chara_05
      chara_06 chara_07 chara_08 chara_09 chara_10
    ]

    ranking_records = []

    base_records.each do |record|
      character_names = chara_columns.map { |c| record[c] }
      character_names = character_names.compact_blank.reject { |el| el == "FALSE"}

      # キャラが複数いる場合には分割する（一キャラ一台詞一レコード）
      # この分割の結果、ツイート人数（DM人数）とキャラレコード数が一致しなくなることに注意する
      character_names.each do |character_name|
        inserted_hash = {}

        inserted_hash[:vote_method] = record.vote_method
        inserted_hash[:character_name] = character_name

        ranking_records << inserted_hash
      end
    end

    ranking_records.sort_by do |element|
      [element[:character_name]]
    end
  end

  def self.ranking_result_illustrations
    base_records = OnRawSheetResultIllustrationTotalling.all.reject do |record|
      record.character_name_by_sheet_totalling.start_with?('TEMP_')
    end

    ranking_records = []

    base_records.each do |record|
      ranking_records << {
        name: record.character_name_by_sheet_totalling,
        number_of_applications: record.number_of_applications
      }
    end

    ranking_records.sort_by do |element|
      [
        element[:name], element[:number_of_applications]
      ]
    end
  end

  def self.ranking_op_cl_illustrations
    all_characters_base_records = CountingAllCharacter.where(vote_method: :op_cl_illustrations_bonus)
    all_characters_ranking_records = []
    all_characters_base_records.each do |record|
      result_array_all_characters << {
        chara_1: record.chara_1
      }
    end

    unite_attacks_ranking_records = []
    unite_attacks_base_records = CountingUniteAttack.where(vote_method: :op_cl_illustrations_bonus)
    unite_attacks_base_records.each do |record|
      result_array_unite_attacks << {
        product_name: record.product_name,
        unite_attack_name: record.unite_attack_name
      }
    end

    {
      all_characters: all_characters_ranking_records,
      unite_attacks: unite_attacks_ranking_records
    }
  end

  def self.ranking_sosenkyo_campaigns
    base_records = CountingBonusVote.valid_records.where(bonus_category: :sosenkyo_campaigns)

    chara_columns = %i[
      chara_01 chara_02 chara_03 chara_04 chara_05
      chara_06 chara_07 chara_08 chara_09 chara_10
    ]
    ranking_records = []

    base_records.each do |record|
      character_names = chara_columns.map { |c| record[c] }
      character_names = character_names.compact_blank.reject { |el| el == "FALSE"}

      # キャラが複数いる場合には分割する（一キャラ一台詞一レコード）
      # この分割の結果、ツイート人数（DM人数）とキャラレコード数が一致しなくなることに注意する
      character_names.each do |character_name|
        ranking_records << {
          vote_method: record.vote_method,
          character_name: character_name,
          contents: record.contents
        }
      end
    end

    ranking_records.sort_by do |element|
      [element[:character_name]]
    end
  end

  # category_name は書き込み対象のシートを指している（名前が良くないので変えるべき）
  # 書き込み対象のシートによって何を書き込むかが異なるので、base_records がいろいろ変わる
  # base_records のソースが必ずしも CountingBonusVote のレコードであるとは限らない
  def self.ranking(written_sheet_name)
    return unless written_sheet_name.in?(
      [
        'ボ・お題小説',
        'ボ・推し台詞',
        'ボ・開票イラスト',
        'ボ・選挙運動',
        'ボ・OP・CLイラスト（オールキャラ）',
      ]
    )

    if written_sheet_name.in?(['ボ・推し台詞'])
      base_records = CountingBonusVote.valid_records.where(bonus_category: :fav_quotes)
      chara_columns = %i[chara_01 chara_02 chara_03 chara_04 chara_05 chara_06 chara_07 chara_08 chara_09 chara_10]
      ret_array = []

      base_records.each do |record|
        character_names = chara_columns.map { |c| record[c] }
        character_names = character_names.compact_blank.reject { |el| el == "FALSE"}

        # キャラが複数いる場合には分割する（一キャラ一台詞一レコード）
        # この分割の結果、ツイート人数（DM人数）とキャラレコード数が一致しなくなることに注意する
        character_names.each do |character_name|
          inserted_hash = {}

          inserted_hash[:vote_method] = record.vote_method
          inserted_hash[:character_name] = character_name

          ret_array << inserted_hash
        end
      end

      return ret_array
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

  def contents_resource
    case vote_method
    when 'by_tweet'
      tweet
    when 'by_direct_message'
      direct_message
    end
  end
end
