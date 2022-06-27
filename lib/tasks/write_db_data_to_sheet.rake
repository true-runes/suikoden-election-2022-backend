namespace :write_db_data_to_sheet do
  desc '[オールキャラ部門] DBのデータをシートに書き込む'
  task all_characters: :environment do
    Sheets::WriteAndUpdate::AllCharacters.exec
  end

  desc '[協力攻撃部門] DBのデータをシートに書き込む'
  task unite_attacks: :environment do
    Sheets::WriteAndUpdate::UniteAttacks.exec
  end

  desc '[ボーナス票・お題小説] DBのデータをシートに書き込む'
  task short_stories: :environment do
    Sheets::WriteAndUpdate::ShortStories.exec
  end

  desc '[ボーナス票・推し台詞] DBのデータをシートに書き込む'
  task fav_quotes: :environment do
    Sheets::WriteAndUpdate::FavQuotes.exec
  end

  desc '[ボーナス票・選挙運動] DBのデータをシートに書き込む'
  task sosenkyo_campaigns: :environment do
    Sheets::WriteAndUpdate::SosenkyoCampaigns.exec
  end

  desc '[ダイレクトメッセージ] DBのダイレクトメッセージのデータをシートに書き込む'
  task direct_messages: :environment do
    Sheets::WriteAndUpdate::DirectMessages.exec
  end
end
