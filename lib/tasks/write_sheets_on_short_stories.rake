namespace :write_sheets_on_short_stories do
  desc '「お題小説」のシートに書き込む'
  task exec: :environment do
    # EventBasicData.sheet_names
    sheet_name = 'ボーナス票・お題小説'

    puts sheet_name
  end
end
