namespace :write_to_sheet do
  desc '（オールキャラ）DBのデータをシートに書き込む'
  task all_characters: :environment do
    Sheets::WriteAndUpdate::AllCharacters.exec
  end
end
