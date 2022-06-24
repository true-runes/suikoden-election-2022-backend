class RealtimeReportController < ApplicationController
  def index
    return render json: blank_response if params["request_spec"] == "true"

    response = {
      all_characters: response_contents(RealtimeReport.where(target_name: 'all_characters').order(date: :asc, hour: :asc)),
      unite_attacks: response_contents(RealtimeReport.where(target_name: 'unite_attacks').order(date: :asc, hour: :asc)),
      fav_quotes: response_contents(RealtimeReport.where(target_name: 'fav_quotes').order(date: :asc, hour: :asc)),
      short_stories: response_contents(RealtimeReport.where(target_name: 'short_stories').order(date: :asc, hour: :asc)),
      sosenkyo_campaigns: response_contents(RealtimeReport.where(target_name: 'sosenkyo_campaigns').order(date: :asc, hour: :asc))
    }

    render json: response
  end

  private

  # TODO: リファクタリング
  def response_contents(realtime_reports) # rubocop:disable Metrics/MethodLength
    records_20220624 = realtime_reports.where(date: '2022-06-24')
    records_20220625 = realtime_reports.where(date: '2022-06-25')
    records_20220626 = realtime_reports.where(date: '2022-06-26')

    {
      sum: realtime_reports.sum(:vote_count),
      votes_per_day: {
        '2020-06-24': records_20220624.sum(:vote_count),
        '2020-06-25': records_20220625.sum(:vote_count),
        '2020-06-26': records_20220626.sum(:vote_count)
      },
      votes_per_hour: {
        '2020-06-24': {
          '00': records_20220624[0].vote_count,
          '01': records_20220624[1].vote_count,
          '02': records_20220624[2].vote_count,
          '03': records_20220624[3].vote_count,
          '04': records_20220624[4].vote_count,
          '05': records_20220624[5].vote_count,
          '06': records_20220624[6].vote_count,
          '07': records_20220624[7].vote_count,
          '08': records_20220624[8].vote_count,
          '09': records_20220624[9].vote_count,
          '10': records_20220624[10].vote_count,
          '11': records_20220624[11].vote_count,
          '12': records_20220624[12].vote_count,
          '13': records_20220624[13].vote_count,
          '14': records_20220624[14].vote_count,
          '15': records_20220624[15].vote_count,
          '16': records_20220624[16].vote_count,
          '17': records_20220624[17].vote_count,
          '18': records_20220624[18].vote_count,
          '19': records_20220624[19].vote_count,
          '20': records_20220624[20].vote_count,
          '21': records_20220624[21].vote_count,
          '22': records_20220624[22].vote_count,
          '23': records_20220624[23].vote_count
        },
        '2020-06-25': {
          '00': records_20220625[0].vote_count,
          '01': records_20220625[1].vote_count,
          '02': records_20220625[2].vote_count,
          '03': records_20220625[3].vote_count,
          '04': records_20220625[4].vote_count,
          '05': records_20220625[5].vote_count,
          '06': records_20220625[6].vote_count,
          '07': records_20220625[7].vote_count,
          '08': records_20220625[8].vote_count,
          '09': records_20220625[9].vote_count,
          '10': records_20220625[10].vote_count,
          '11': records_20220625[11].vote_count,
          '12': records_20220625[12].vote_count,
          '13': records_20220625[13].vote_count,
          '14': records_20220625[14].vote_count,
          '15': records_20220625[15].vote_count,
          '16': records_20220625[16].vote_count,
          '17': records_20220625[17].vote_count,
          '18': records_20220625[18].vote_count,
          '19': records_20220625[19].vote_count,
          '20': records_20220625[20].vote_count,
          '21': records_20220625[21].vote_count,
          '22': records_20220625[22].vote_count,
          '23': records_20220625[23].vote_count
        },
        '2020-06-26': {
          '00': records_20220626[0].vote_count,
          '01': records_20220626[1].vote_count,
          '02': records_20220626[2].vote_count,
          '03': records_20220626[3].vote_count,
          '04': records_20220626[4].vote_count,
          '05': records_20220626[5].vote_count,
          '06': records_20220626[6].vote_count,
          '07': records_20220626[7].vote_count,
          '08': records_20220626[8].vote_count,
          '09': records_20220626[9].vote_count,
          '10': records_20220626[10].vote_count,
          '11': records_20220626[11].vote_count,
          '12': records_20220626[12].vote_count,
          '13': records_20220626[13].vote_count,
          '14': records_20220626[14].vote_count,
          '15': records_20220626[15].vote_count,
          '16': records_20220626[16].vote_count,
          '17': records_20220626[17].vote_count,
          '18': records_20220626[18].vote_count,
          '19': records_20220626[19].vote_count,
          '20': records_20220626[20].vote_count,
          '21': records_20220626[21].vote_count,
          '22': records_20220626[22].vote_count,
          '23': records_20220626[23].vote_count
        }
      },
      votes_per_lang: {
        ja: realtime_reports.sum(:vote_lang_count_ja),
        others: realtime_reports.sum(:vote_lang_count_others)
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
