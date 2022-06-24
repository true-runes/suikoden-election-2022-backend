class RealtimeReportController < ApplicationController
  def index
    render json: Counting::RealtimeReport.run
  end
end
