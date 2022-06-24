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

        attack = res.first

        expect(attack.keys).to eq [
          'id',
          'name',
          'kana',
          'name_en',
          'chara_1',
          'chara_2',
          'chara_3',
          'chara_4',
          'chara_5',
          'chara_6',
          'page_annotation',
          'character_names',
        ]
        expect(attack['name']).to eq 'ダブルリーダー攻撃'
        expect(attack['kana']).to eq 'だぶるりーだー'
        expect(attack['name_en']).to eq 'Double Leader Attack'
        expect(attack['chara_1']).to eq '主人公'
        expect(attack['chara_2']).to eq '1主人公'
        expect(attack['chara_3']).to eq nil
        expect(attack['chara_4']).to eq nil
        expect(attack['chara_5']).to eq nil
        expect(attack['chara_6']).to eq nil
        expect(attack['chara_6']).to eq nil
        expect(attack['page_annotation']).to eq nil
        expect(attack['character_names']).not_to eq '主人公＆1主人公'
        expect(attack['character_names']).to eq '1主人公＆主人公'
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
        expect(record['character_names']).not_to eq '主人公＆1主人公'
        expect(record['character_names']).to eq '1主人公＆主人公'
        expect(record['page_annotation']).to eq nil
      end
    end
  end
end
