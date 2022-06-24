require 'rails_helper'

RSpec.describe RealtimeReportController, type: :request do
  describe '#index' do
    it '期待通りのレスポンスが返ってくること' do
      # TODO: パラメータはテスト用の一時的なものなので、きちんと書く
      get realtime_report_path, params: { request_spec: 'true' }

      expect(response).to have_http_status :ok

      hashed_json = JSON.parse(response.body)

      expect(hashed_json.keys).to match_array %w(
        all_characters
        unite_attacks
        fav_quotes
        short_stories
        sosenkyo_campaigns
      )

      ['all_characters', 'unite_attacks', 'fav_quotes', 'short_stories', 'sosenkyo_campaigns'].each do |key|
        expect(hashed_json[key].keys).to match_array %w(
          sum
          votes_per_day
          votes_per_hour
          votes_per_lang
        )
      end
    end
  end
end
