namespace :realtime_report do
  desc 'リアルタイムレポートのデータベースのデータを更新する'
  task update: :environment do
    Counting::RealtimeReport.update_database

    '[DONE] Counting::RealtimeReport.update_database'
  end
end
