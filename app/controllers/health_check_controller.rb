class HealthCheckController < ApplicationController
  def index
    return render json: { status: 'Ok!' } unless request.headers[:'X-Gensosenkyo-Key'] == ENV['X_GENSOSENKYO_KEY']

    render json: { status: 'Great!' }
  end
end
