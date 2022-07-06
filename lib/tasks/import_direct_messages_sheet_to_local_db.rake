namespace :import_direct_messages_sheet_to_local_db do
  desc '「オールキャラ部門」のDM投票の開票データをスプレッドシートからインポートする'
  task all_characters: :environment do
    Sheets::Counting::AllCharacters.import_via_dm
  end

  desc '「ボーナス票」の各対象DM投票の開票データをスプレッドシートからインポートする'
  task bonus_votes: :environment do
    Sheets::Counting::BonusVotes.import_via_dm
  end

  desc '「協力攻撃部門」のDM投票の開票データをスプレッドシートからインポートする'
  task unite_attacks: :environment do
    Sheets::Counting::UniteAttacks.import_via_dm
  end
end
