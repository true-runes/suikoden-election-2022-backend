namespace :write_to_sheet do
  desc '[オールキャラ部門] DBのデータをシートに書き込む'
  task all_characters: :environment do
    Sheets::WriteAndUpdate::AllCharacters.exec
  end

  desc '[協力攻撃部門] DBのデータをシートに書き込む'
  task unite_attacks: :environment do
    Sheets::WriteAndUpdate::UniteAttacks.exec
  end
end
