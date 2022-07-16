module Stats
  # 「部門」としての投票を計算する
  class DivisionAllCharacters
    attr_reader :counting_division_all_characters, :final_division_all_characters_rows, :base_records

    def initialize
      @final_division_all_characters_rows = set_final_division_all_characters_rows
      @counting_division_all_characters = CountingAllCharacter.ranking
      @base_records = CountingAllCharacter.valid_records
    end

    def number_of_aopplications
      final_division_all_characters_rows.pluck(:number_of_votes).sum
    end

    def vote_methods
      # FIXME: 3票を3つのツイートで分けた場合のケースが未考慮
      # 人数と投票数の 2つ の観点が必要
      @base_records.pluck(:vote_method).tally.sort_by { |_, v| v }.reverse
    end

    # レコードの id や、レコード自体を配列で返したほうが使い勝手が良くなる
    def number_of_votes_per_user
      one = 0
      two = 0
      three = 0

      # FIXME: 3票を3つのツイートで分けた場合のケースが未考慮
      base_records.each do |record|
        characters = [
          record.chara_1,
          record.chara_2,
          record.chara_3,
        ].compact_blank

        case characters.size
        when 1
          one += 1
        when 2
          two += 1
        when 3
          three += 1
        end
      end

      {
        one: one,
        two: two,
        three: three
      }
    end

    def number_of_users
      applying_users.size
    end

    def applying_users
      records = @base_records.where.not(vote_method: :op_cl_illustrations_bonus).includes(:user)

      records.map(&:user).uniq
    end

    def languages
      records = votes_by_users(applying_users)

      languages = records.map do |record|
        case record.vote_method
        when 'by_tweet'
          record.tweet.present? ? record.tweet.language : 'Unknown'
        when 'by_direct_message'
          'Direct Message'
        when 'op_cl_illustrations_bonus'
          'ja'
        end
      end

      languages.tally.sort_by { |_, v| v }.reverse
    end

    def languages_whose_unit_is_tweet
      records = votes_by_users(applying_users)

      languages = records.map do |record|
        case record.vote_method
        when 'by_tweet'
          lang = record.tweet.present? ? record.tweet.language : 'Unknown'
          lang * valid_votes_number_in_record(record)
        when 'by_direct_message'
          'Direct Message' * valid_votes_number_in_record(record)
        when 'op_cl_illustrations_bonus'
          'ja' * valid_votes_number_in_record(record)
        end
      end

      languages.tally.sort_by { |_, v| v }.reverse
    end

    def votes_by_users(users)
      @base_records.where(user: users)
    end

    def valid_votes_number_in_record(record)
      voted_characters = [
        record.chara_1,
        record.chara_2,
        record.chara_3,
      ].compact_blank

      voted_characters.size
    end

    private

    def set_final_division_all_characters_rows
      sheet_name = '単体・①オールキャラ部門'
      rows = SheetData.get_rows(
        sheet_id: ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil),
        range: "#{sheet_name}!B2:L501"
      )

      rows.map do |row|
        {
          rank: row[0],
          character_name: row[1],
          number_of_votes: row[2].to_i,
          result_illustration_exist: row[4],
          fav_quotes_exist: row[5],
          product_names: row[6],
          exist_in_character_db: row[7],
          tweet_template: row[9]
        }
      end
    end
  end
end
