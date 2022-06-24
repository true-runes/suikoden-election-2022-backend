class AddResponseJsonColumnToRealtimeReports < ActiveRecord::Migration[7.0]
  def change
    add_column :realtime_reports, :response_json, :json
  end
end
