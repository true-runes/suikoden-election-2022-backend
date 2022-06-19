require 'rails_helper'

RSpec.describe UniteAttacksController, type: :request do
  let!(:s1) { create_list(:on_raw_sheet_unite_attack, 10, :s1) }
  let!(:s2) { create_list(:on_raw_sheet_unite_attack, 10) }
  let!(:s3) { create_list(:on_raw_sheet_unite_attack, 10, :s3) }
  let!(:s4) { create_list(:on_raw_sheet_unite_attack, 10, :s4) }
  let!(:tactics) { create_list(:on_raw_sheet_unite_attack, 10, :tactics) }
  let!(:s5) { create_list(:on_raw_sheet_unite_attack, 10, :s5) }
  let!(:tk) { create_list(:on_raw_sheet_unite_attack, 10, :tk) }
  let!(:woven) { create_list(:on_raw_sheet_unite_attack, 10, :woven) }

  describe '#index' do
    context 'パラメータなしのとき' do
      it '200 が返ってくること' do
        get unite_attacks_path

        expect(response).to have_http_status :ok
      end
    end

    context 'パラメータがあるとき' do
      it 'title=s1 のときに期待通りのレスポンスが返ってくること' do
        get unite_attacks_path, params: { title: 's1' }

        expect(response).to have_http_status :ok

        res = JSON.parse(response.body)

        expect(res.class).to eq Array
        expect(res.size).to eq 10
      end

      it 'title=tk のときに期待通りのレスポンスが返ってくること' do
        get unite_attacks_path, params: { title: 'tk' }

        expect(response).to have_http_status :ok

        res = JSON.parse(response.body)

        expect(res.class).to eq Array
        expect(res.size).to eq 10
      end

      it 'title=all のときに期待通りのレスポンスが返ってくること' do
        get unite_attacks_path, params: { title: 'all' }

        expect(response).to have_http_status :ok

        res = JSON.parse(response.body)

        expect(res.class).to eq Array
        expect(res.size).to eq 80
      end
    end
  end
end
