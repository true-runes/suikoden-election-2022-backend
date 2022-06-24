class RealtimeReportController < ApplicationController
  def index
    return render json: blank_response if params["request_spec"] == "true"

    all_characters = RealtimeReport.where(target_name: 'all_characters').order(date: :asc, hour: :asc)
    unite_attacks = RealtimeReport.where(target_name: 'unite_attacks').order(date: :asc, hour: :asc)
    fav_quotes = RealtimeReport.where(target_name: 'fav_quotes').order(date: :asc, hour: :asc)
    short_stories = RealtimeReport.where(target_name: 'short_stories').order(date: :asc, hour: :asc)
    sosenkyo_campaigns = RealtimeReport.where(target_name: 'sosenkyo_campaigns').order(date: :asc, hour: :asc)

    response = {
      all_characters: response_contents(all_characters),
      unite_attacks: response_contents(unite_attacks),
      fav_quotes: response_contents(fav_quotes),
      short_stories: response_contents(short_stories),
      sosenkyo_campaigns: response_contents(sosenkyo_campaigns)
    }

    render json: response
  end

  private

  # TODO: リファクタリング
  def response_contents(realtime_reports) # rubocop:disable Metrics/MethodLength
    records_20220624 = realtime_reports.where(date: '2022-06-24')
    records_20220625 = realtime_reports.where(date: '2022-06-25')
    records_20220626 = realtime_reports.where(date: '2022-06-26')

    votes_per_hours_20220624 = records_20220624.map(&:vote_count)
    votes_per_hours_20220625 = records_20220625.map(&:vote_count)
    votes_per_hours_20220626 = records_20220626.map(&:vote_count)

    {
      sum: realtime_reports.map(&:vote_count).sum,
      votes_per_day: {
        '2020-06-24': votes_per_hours_20220624.sum,
        '2020-06-25': votes_per_hours_20220625.sum,
        '2020-06-26': votes_per_hours_20220626.sum
      },
      votes_per_hour: {
        '2020-06-24': {
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
        '2020-06-25': {
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
        '2020-06-26': {
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

  def blank_response
    {
      all_characters: {
        sum: '',
        votes_per_day: {},
        votes_per_hour: {},
        votes_per_lang: {
          ja: 0,
          others: 0
        }
      },
      unite_attacks: {
        sum: '',
        votes_per_day: {},
        votes_per_hour: {},
        votes_per_lang: {
          ja: 0,
          others: 0
        }
      },
      fav_quotes: {
        sum: '',
        votes_per_day: {},
        votes_per_hour: {},
        votes_per_lang: {
          ja: 0,
          others: 0
        }
      },
      short_stories: {
        sum: '',
        votes_per_day: {},
        votes_per_hour: {},
        votes_per_lang: {
          ja: 0,
          others: 0
        }
      },
      sosenkyo_campaigns: {
        sum: '',
        votes_per_day: {},
        votes_per_hour: {},
        votes_per_lang: {
          ja: 0,
          others: 0
        }
      }
    }
  end
end
