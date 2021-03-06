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

        all_realtime_reports = ::RealtimeReport.all

        all_realtime_reports.each do |realtime_report|
          realtime_report.update(response_json: this_response_json)
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

    def self.this_response_json
      all_characters = ::RealtimeReport.where(target_name: 'all_characters').order(date: :asc, hour: :asc)
      unite_attacks = ::RealtimeReport.where(target_name: 'unite_attacks').order(date: :asc, hour: :asc)
      fav_quotes = ::RealtimeReport.where(target_name: 'fav_quotes').order(date: :asc, hour: :asc)
      short_stories = ::RealtimeReport.where(target_name: 'short_stories').order(date: :asc, hour: :asc)
      sosenkyo_campaigns = ::RealtimeReport.where(target_name: 'sosenkyo_campaigns').order(date: :asc, hour: :asc)

      {
        all_characters: response_contents(all_characters),
        unite_attacks: response_contents(unite_attacks),
        fav_quotes: response_contents(fav_quotes),
        short_stories: response_contents(short_stories),
        sosenkyo_campaigns: response_contents(sosenkyo_campaigns)
      }
    end

    def self.response_contents(realtime_reports) # rubocop:disable Metrics/MethodLength
      records_20220624 = realtime_reports.where(date: '2022-06-24')
      records_20220625 = realtime_reports.where(date: '2022-06-25')
      records_20220626 = realtime_reports.where(date: '2022-06-26')

      votes_per_hours_20220624 = records_20220624.map(&:vote_count)
      votes_per_hours_20220625 = records_20220625.map(&:vote_count)
      votes_per_hours_20220626 = records_20220626.map(&:vote_count)

      {
        sum: realtime_reports.map(&:vote_count).sum,
        votes_per_day: {
          '2022-06-24': votes_per_hours_20220624.sum,
          '2022-06-25': votes_per_hours_20220625.sum,
          '2022-06-26': votes_per_hours_20220626.sum
        },
        votes_per_hour: {
          '2022-06-24': {
            '00': votes_per_hours_20220624[0],
            '01': votes_per_hours_20220624[1],
            '02': votes_per_hours_20220624[2],
            '03': votes_per_hours_20220624[3],
            '04': votes_per_hours_20220624[4],
            '05': votes_per_hours_20220624[5],
            '06': votes_per_hours_20220624[6],
            '07': votes_per_hours_20220624[7],
            '08': votes_per_hours_20220624[8],
            '09': votes_per_hours_20220624[9],
            '10': votes_per_hours_20220624[10],
            '11': votes_per_hours_20220624[11],
            '12': votes_per_hours_20220624[12],
            '13': votes_per_hours_20220624[13],
            '14': votes_per_hours_20220624[14],
            '15': votes_per_hours_20220624[15],
            '16': votes_per_hours_20220624[16],
            '17': votes_per_hours_20220624[17],
            '18': votes_per_hours_20220624[18],
            '19': votes_per_hours_20220624[19],
            '20': votes_per_hours_20220624[20],
            '21': votes_per_hours_20220624[21],
            '22': votes_per_hours_20220624[22],
            '23': votes_per_hours_20220624[23]
          },
          '2022-06-25': {
            '00': votes_per_hours_20220625[0],
            '01': votes_per_hours_20220625[1],
            '02': votes_per_hours_20220625[2],
            '03': votes_per_hours_20220625[3],
            '04': votes_per_hours_20220625[4],
            '05': votes_per_hours_20220625[5],
            '06': votes_per_hours_20220625[6],
            '07': votes_per_hours_20220625[7],
            '08': votes_per_hours_20220625[8],
            '09': votes_per_hours_20220625[9],
            '10': votes_per_hours_20220625[10],
            '11': votes_per_hours_20220625[11],
            '12': votes_per_hours_20220625[12],
            '13': votes_per_hours_20220625[13],
            '14': votes_per_hours_20220625[14],
            '15': votes_per_hours_20220625[15],
            '16': votes_per_hours_20220625[16],
            '17': votes_per_hours_20220625[17],
            '18': votes_per_hours_20220625[18],
            '19': votes_per_hours_20220625[19],
            '20': votes_per_hours_20220625[20],
            '21': votes_per_hours_20220625[21],
            '22': votes_per_hours_20220625[22],
            '23': votes_per_hours_20220625[23]
          },
          '2022-06-26': {
            '00': votes_per_hours_20220626[0],
            '01': votes_per_hours_20220626[1],
            '02': votes_per_hours_20220626[2],
            '03': votes_per_hours_20220626[3],
            '04': votes_per_hours_20220626[4],
            '05': votes_per_hours_20220626[5],
            '06': votes_per_hours_20220626[6],
            '07': votes_per_hours_20220626[7],
            '08': votes_per_hours_20220626[8],
            '09': votes_per_hours_20220626[9],
            '10': votes_per_hours_20220626[10],
            '11': votes_per_hours_20220626[11],
            '12': votes_per_hours_20220626[12],
            '13': votes_per_hours_20220626[13],
            '14': votes_per_hours_20220626[14],
            '15': votes_per_hours_20220626[15],
            '16': votes_per_hours_20220626[16],
            '17': votes_per_hours_20220626[17],
            '18': votes_per_hours_20220626[18],
            '19': votes_per_hours_20220626[19],
            '20': votes_per_hours_20220626[20],
            '21': votes_per_hours_20220626[21],
            '22': votes_per_hours_20220626[22],
            '23': votes_per_hours_20220626[23]
          }
        },
        votes_per_lang: {
          ja: realtime_reports.map(&:vote_lang_count_ja).sum,
          others: realtime_reports.map(&:vote_lang_count_others).sum
        }
      }
    end
  end
end
