require 'rails_helper'

RSpec.describe ResultIllustrationApplicationsController, type: :request do
  describe '#index' do
    let!(:record_01) { create(:on_raw_sheet_result_illustration_totalling, character_name_for_public: 'ワカバ') }
    let!(:record_02) { create(:on_raw_sheet_result_illustration_totalling, character_name_for_public: 'アップル') }
    let!(:record_03) { create(:on_raw_sheet_result_illustration_totalling, character_name_for_public: 'コルセリア') }

    context 'パラメータなしのとき' do
      it '200 が返ってくること' do
        get result_illustration_applications_path

        expect(response).to have_http_status :ok
      end

      it '期待通りのレスポンスが返ってくること' do
        get result_illustration_applications_path

        expect(response).to have_http_status :ok

        res = JSON.parse(response.body)

        expect(res.class).to eq Hash
        expect(res.keys.size).to eq 2
        expect(res.keys).to eq (
          [
            'last_updated_at',
            'character_names',
          ]
        )

        last_created_at = record_01.created_at
        last_updated_at_date = Presenter::Common.japanese_date_strftime(last_created_at, with_day_of_the_week: true)
        last_updated_at_time = Presenter::Common.japanese_clock_time_strftime(last_created_at, with_seconds: false)
        expect(res["last_updated_at"]).to eq "#{last_updated_at_date}#{last_updated_at_time}"

        character_names = res["character_names"]
        expect(character_names.size).to eq 3

        # ソートされていることを確かめる
        expect(character_names[0]).to eq 'アップル'
        expect(character_names[1]).to eq 'コルセリア'
        expect(character_names[2]).to eq 'ワカバ'
      end
    end
  end
end
