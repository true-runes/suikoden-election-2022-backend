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

        expect(res.class).to eq Array
        expect(res.size).to eq 3
        # ソートされていることを確かめる
        expect(res[0]).to eq 'アップル'
        expect(res[1]).to eq 'コルセリア'
        expect(res[2]).to eq 'ワカバ'
      end
    end
  end
end
