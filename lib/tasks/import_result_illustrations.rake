namespace :import_result_illustrations do
  desc '「開票イラスト」のデータをスプレッドシートからインポートする'
  task exec: :environment do
    puts Sheets::ResultIllustrationApplications.import_totallings_data_to_database
  end
end
