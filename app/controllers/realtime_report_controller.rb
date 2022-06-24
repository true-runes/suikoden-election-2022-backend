class RealtimeReportController < ApplicationController
  def index
    return render json: blank_response if params["request_spec"] == "true"

    render json: RealtimeReport.first.response_json
  end

  private

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
