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

        expect(res.class).to eq Hash
        expect(res.keys).to eq [
          '幻想水滸伝',
          '幻想水滸伝II',
          '幻想水滸伝III',
          '幻想水滸伝IV',
          'ラプソディア',
          '幻想水滸伝V',
          '幻想水滸伝ティアクライス',
          '幻想水滸伝 紡がれし百年の時',
        ]

        record = res['幻想水滸伝'].first

        expect(record.keys).to eq [
          'id',
          'name',
          'name_en',
          'character_names',
          'page_annotation',
        ]
        expect(record['name']).to eq 'ダブルリーダー攻撃'
        expect(record['name_en']).to eq 'Double Leader Attack'
        expect(record['character_names']).to eq '主人公＆1主人公'
        expect(record['page_annotation']).to eq nil
      end
    end
  end
end
