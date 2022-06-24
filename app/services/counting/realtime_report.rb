module Counting
  class RealtimeReport
    def self.update_database
      target_names = %w(
        all_characters
        unite_attacks
        short_stories
        fav_quotes
        sosenkyo_campaigns
      )
      dates = %w(
        2022-06-24
        2022-06-25
        2022-06-26
      )
      hours = [
        '00', '01', '02', '03', '04', '05', '06',
        '07', '08', '09', '10', '11', '12', '13',
        '14', '15', '16', '17', '18', '19', '20',
        '21', '22', '23'
      ]

      ActiveRecord::Base.transaction do
        target_names.each do |target_name|
          tweets = target_name_vs_tweets(target_name)

          dates.each do |date|
            hours.each do |hour|
              save_data(target_name, tweets, date, hour)
            end
          end
        end
      end
    end

    def self.save_data(target_name, tweets, date, hour)
      vote_count = must_zero_vote_count?(date, hour) ? 0 : tweets.where(tweeted_at: Time.zone.parse("#{date} #{hour}:00:00")..Time.zone.parse("#{date} #{hour}:59:59")).count
      vote_lang_count_ja = must_zero_vote_count?(date, hour) ? 0 : tweets.where(tweeted_at: Time.zone.parse("#{date} #{hour}:00:00")..Time.zone.parse("#{date} #{hour}:59:59")).where(language: 'ja').count
      vote_lang_count_others = must_zero_vote_count?(date, hour) ? 0 : tweets.where(tweeted_at: Time.zone.parse("#{date} #{hour}:00:00")..Time.zone.parse("#{date} #{hour}:59:59")).where.not(language: 'ja').count

      unique_attrs = {
        target_name: target_name,
        date: date,
        hour: hour
      }

      attrs = {
        vote_count: vote_count,
        vote_lang_count_ja: vote_lang_count_ja,
        vote_lang_count_others: vote_lang_count_others
      }

      ::RealtimeReport.find_or_initialize_by(unique_attrs).update!(attrs)
    end

    # 厳密である必要はないから、いったん全部 false で返す
    def self.must_zero_vote_count?(_date, _hour)
      false

      # date == '2022-06-24' && hour.in?(['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20'])
    end

    # 厳密である必要はないから _api のメソッドは使わない
    def self.target_name_vs_tweets(target_name)
      case target_name
      when 'all_characters'
        Tweet.gensosenkyo_2022_votes
      when 'unite_attacks'
        Tweet.unite_attacks_votes
      when 'short_stories'
        Tweet.short_stories
      when 'fav_quotes'
        Tweet.fav_quotes
      when 'sosenkyo_campaigns'
        Tweet.sosenkyo_campaigns
      end
    end
  end
end
