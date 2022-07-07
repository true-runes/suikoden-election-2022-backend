namespace :final_ranking do
  desc '「単体・①オールキャラ部門」の最終結果をスプレッドシートに書き込む'
  task all_characters_stand_alone: :environment do
    o = Sheets::WriteAndUpdate::FinalResults::AllCharactersStandAlone.new

    o.exec
  end

  desc '「②協力攻撃部門」の最終結果をスプレッドシートに書き込む'
  task unite_attacks: :environment do
    o = Sheets::WriteAndUpdate::FinalResults::UniteAttacks.new

    o.exec
  end
end
