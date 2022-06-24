module Counting
  class RealtimeReport
    def self.run
      {
        all_characters: data(Tweet.gensosenkyo_2022_votes_for_api),
        unite_attacks: data(Tweet.unite_attacks_votes_for_api),
        short_stories: limited_data(Tweet.short_stories_for_api),
        fav_quotes: limited_data(Tweet.fav_quotes_for_api),
        sosenkyo_campaigns: limited_data(Tweet.sosenkyo_campaigns_for_api)
      }
    end

    # TODO: リファクタリング
    def self.data(tweets) # rubocop:disable Metrics/MethodLength
      {
        sum: tweets.count,
        votes_per_day: {
          '2022-06-24': tweets.where(tweeted_at: Time.zone.parse('2022-06-24 21:00:00')..Time.zone.parse('2022-06-24 23:59:59')).count,
          '2022-06-25': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 00:00:00')..Time.zone.parse('2022-06-25 23:59:59')).count,
          '2022-06-26': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 00:00:00')..Time.zone.parse('2022-06-26 23:59:59')).count
        },
        votes_per_hour: {
          '2022-06-24': [
            '00': 0,
            '01': 0,
            '02': 0,
            '03': 0,
            '04': 0,
            '05': 0,
            '06': 0,
            '07': 0,
            '08': 0,
            '09': 0,
            '10': 0,
            '11': 0,
            '12': 0,
            '13': 0,
            '14': 0,
            '15': 0,
            '16': 0,
            '17': 0,
            '18': 0,
            '19': 0,
            '20': 0,
            '21': tweets.where(tweeted_at: Time.zone.parse('2022-06-24 21:00:00')..Time.zone.parse('2022-06-24 21:59:59')).count,
            '22': tweets.where(tweeted_at: Time.zone.parse('2022-06-24 22:00:00')..Time.zone.parse('2022-06-24 22:59:59')).count,
            '23': tweets.where(tweeted_at: Time.zone.parse('2022-06-24 23:00:00')..Time.zone.parse('2022-06-24 23:59:59')).count,
          ],
          '2022-06-25': [
            '00': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 00:00:00')..Time.zone.parse('2022-06-25 00:59:59')).count,
            '01': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 01:00:00')..Time.zone.parse('2022-06-25 01:59:59')).count,
            '02': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 02:00:00')..Time.zone.parse('2022-06-25 02:59:59')).count,
            '03': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 03:00:00')..Time.zone.parse('2022-06-25 03:59:59')).count,
            '04': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 04:00:00')..Time.zone.parse('2022-06-25 04:59:59')).count,
            '05': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 05:00:00')..Time.zone.parse('2022-06-25 05:59:59')).count,
            '06': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 06:00:00')..Time.zone.parse('2022-06-25 06:59:59')).count,
            '07': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 07:00:00')..Time.zone.parse('2022-06-25 07:59:59')).count,
            '08': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 08:00:00')..Time.zone.parse('2022-06-25 08:59:59')).count,
            '09': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 09:00:00')..Time.zone.parse('2022-06-25 09:59:59')).count,
            '10': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 10:00:00')..Time.zone.parse('2022-06-25 10:59:59')).count,
            '11': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 11:00:00')..Time.zone.parse('2022-06-25 11:59:59')).count,
            '12': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 12:00:00')..Time.zone.parse('2022-06-25 12:59:59')).count,
            '13': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 13:00:00')..Time.zone.parse('2022-06-25 13:59:59')).count,
            '14': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 14:00:00')..Time.zone.parse('2022-06-25 14:59:59')).count,
            '15': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 15:00:00')..Time.zone.parse('2022-06-25 15:59:59')).count,
            '16': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 16:00:00')..Time.zone.parse('2022-06-25 16:59:59')).count,
            '17': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 17:00:00')..Time.zone.parse('2022-06-25 17:59:59')).count,
            '18': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 18:00:00')..Time.zone.parse('2022-06-25 18:59:59')).count,
            '19': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 19:00:00')..Time.zone.parse('2022-06-25 19:59:59')).count,
            '20': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 20:00:00')..Time.zone.parse('2022-06-25 20:59:59')).count,
            '21': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 21:00:00')..Time.zone.parse('2022-06-25 21:59:59')).count,
            '22': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 22:00:00')..Time.zone.parse('2022-06-25 22:59:59')).count,
            '23': tweets.where(tweeted_at: Time.zone.parse('2022-06-25 23:00:00')..Time.zone.parse('2022-06-25 23:59:59')).count,
          ],
          '2022-06-26': [
            '00': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 00:00:00')..Time.zone.parse('2022-06-26 00:59:59')).count,
            '01': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 01:00:00')..Time.zone.parse('2022-06-26 01:59:59')).count,
            '02': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 02:00:00')..Time.zone.parse('2022-06-26 02:59:59')).count,
            '03': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 03:00:00')..Time.zone.parse('2022-06-26 03:59:59')).count,
            '04': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 04:00:00')..Time.zone.parse('2022-06-26 04:59:59')).count,
            '05': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 05:00:00')..Time.zone.parse('2022-06-26 05:59:59')).count,
            '06': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 06:00:00')..Time.zone.parse('2022-06-26 06:59:59')).count,
            '07': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 07:00:00')..Time.zone.parse('2022-06-26 07:59:59')).count,
            '08': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 08:00:00')..Time.zone.parse('2022-06-26 08:59:59')).count,
            '09': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 09:00:00')..Time.zone.parse('2022-06-26 09:59:59')).count,
            '10': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 10:00:00')..Time.zone.parse('2022-06-26 10:59:59')).count,
            '11': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 11:00:00')..Time.zone.parse('2022-06-26 11:59:59')).count,
            '12': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 12:00:00')..Time.zone.parse('2022-06-26 12:59:59')).count,
            '13': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 13:00:00')..Time.zone.parse('2022-06-26 13:59:59')).count,
            '14': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 14:00:00')..Time.zone.parse('2022-06-26 14:59:59')).count,
            '15': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 15:00:00')..Time.zone.parse('2022-06-26 15:59:59')).count,
            '16': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 16:00:00')..Time.zone.parse('2022-06-26 16:59:59')).count,
            '17': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 17:00:00')..Time.zone.parse('2022-06-26 17:59:59')).count,
            '18': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 18:00:00')..Time.zone.parse('2022-06-26 18:59:59')).count,
            '19': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 19:00:00')..Time.zone.parse('2022-06-26 19:59:59')).count,
            '20': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 20:00:00')..Time.zone.parse('2022-06-26 20:59:59')).count,
            '21': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 21:00:00')..Time.zone.parse('2022-06-26 21:59:59')).count,
            '22': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 22:00:00')..Time.zone.parse('2022-06-26 22:59:59')).count,
            '23': tweets.where(tweeted_at: Time.zone.parse('2022-06-26 23:00:00')..Time.zone.parse('2022-06-26 23:59:59')).count,
          ]
        },
        # 言語別はここだけとする
        votes_per_lang: {
          ja: tweets.where(language: 'ja').count,
          others: tweets.count - tweets.where(language: 'ja').count
        }
      }
    end

    def self.limited_data(tweets)
      {
        sum: tweets.count,
        votes_per_lang: {
          ja: tweets.where(language: 'ja').count,
          others: tweets.count - tweets.where(language: 'ja').count
        }
      }
    end
  end
end
