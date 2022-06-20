require 'rails_helper'

RSpec.describe HealthCheckController, type: :request do
  describe '#index' do
    before do
      ENV['X_GENSOSENKYO_KEY'] = 'true_runes'
    end

    after do
      ENV['X_GENSOSENKYO_KEY'] = ''
    end

    context 'X-Gensosenkyo-Key がリクエストヘッダに存在しないとき' do
      it '期待通りのレスポンスが返ってくること' do
        get health_check_path

        expect(response).to have_http_status :ok
        expect(response.body).to eq '{"status":"Ok!"}'
      end
    end

    context 'X-Gensosenkyo-Key がリクエストヘッダに存在し、誤っているとき' do
      it '期待通りのレスポンスが返ってくること' do
        get health_check_path, headers: { 'X-Gensosenkyo-Key' => 'false_runes' }

        expect(response).to have_http_status :ok
        expect(response.body).to eq '{"status":"Ok!"}'
      end
    end

    context 'X-Gensosenkyo-Key がリクエストヘッダに存在し、正しいとき' do
      it '期待通りのレスポンスが返ってくること' do
        get health_check_path, headers: { 'X-Gensosenkyo-Key' => 'true_runes' }

        expect(response).to have_http_status :ok
        expect(response.body).to eq '{"status":"Great!"}'
      end
    end
  end
end
