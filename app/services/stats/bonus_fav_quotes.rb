# フロント側の Chart ライブラリ での利用を考え、原則として二次元配列で返す
module Stats
  class BonusFavQuotes
    attr_reader :final_fav_quotes_rows, :counting_fav_quotes

    def initialize
      @final_fav_quotes_rows = set_final_fav_quotes_rows
      @counting_fav_quotes = CountingBonusVote.ranking_fav_quotes
    end

    def vote_methods
      @counting_fav_quotes.pluck(:vote_method).tally.sort_by { |_, v| v }.reverse
    end

    def characters_applied
      @final_fav_quotes_rows.pluck(
        :character_name,
        :number_of_applications
      ).sort_by { |array| [-array[1], array[0]] }
    end

    def number_of_applications
      @counting_fav_quotes.size
    end

    def number_of_users
      fav_quote_records = CountingBonusVote.valid_records.where(bonus_category: :fav_quotes)

      fav_quote_records.group(:user).count.size
    end

    def applying_users
      fav_quote_records = CountingBonusVote.valid_records.where(bonus_category: :fav_quotes)

      fav_quote_records.group(:user).count.keys
    end

    def languages
      records = fav_quotes_by_users(applying_users)

      languages = records.map do |record|
        case record.vote_method
        when 'by_tweet'
          record.tweet.present? ? record.tweet.language : 'Unknown'
        when 'by_direct_message'
          'Direct Message'
        end
      end

      languages.tally.sort_by { |_, v| v }.reverse
    end

    def fav_quotes_by_users(users)
      CountingBonusVote.valid_records.where(
        bonus_category: :fav_quotes,
        user: users
      )
    end

    private

    def set_final_fav_quotes_rows
      sheet_name = 'ボ・推し台詞'
      rows = SheetData.get_rows(
        sheet_id: ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil),
        range: "#{sheet_name}!B2:L501"
      )

      rows.map do |row|
        {
          character_name: row[0],
          number_of_applications: row[1].to_i,
          number_of_votes: row[2].to_i
        }
      end
    end
  end
end
