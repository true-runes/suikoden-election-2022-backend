require 'rails_helper'

RSpec.describe CheckVotesAndBonusesController, type: :request do
  describe '#index' do
    context 'パラメータ screen_name が存在しないとき' do
      it '期待通りのレスポンスが返ってくること' do
        get check_votes_and_bonuses_path

        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)).to eq(
          {
            "screen_name" => "",
            "gss2022" => [],
            "unite_attacks" => [],
            "short_stories" => [],
            "fav_quotes" => [],
            "sosenkyo_campaigns" => []
          }
        )
      end
    end

    context 'パラメータ screen_name が存在するとき' do
      it 'データベースに存在しないとき、期待通りのレスポンスが返ってくること' do
        get check_votes_and_bonuses_path(screen_name: '@test_user')

        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)).to eq(
          {
            "screen_name" => "test_user",
            "gss2022" => [],
            "unite_attacks" => [],
            "short_stories" => [],
            "fav_quotes" => [],
            "sosenkyo_campaigns" => []
          }
        )
      end

      it 'データベースに存在するとき、期待通りのレスポンスが返ってくること' do
        create(:user)

        get check_votes_and_bonuses_path(screen_name: '@test_screen_name')

        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)).to eq(
          {
            "screen_name" => "test_screen_name",
            "gss2022" => [],
            "unite_attacks" => [],
            "short_stories" => [],
            "fav_quotes" => [],
            "sosenkyo_campaigns" => []
          }
        )
      end
    end
  end
end
