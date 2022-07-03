namespace :import_counting_unite_attacks do
  desc '「協力攻撃部門」のツイート投票の開票データをスプレッドシートからインポートする'
  task exec_via_tweet: :environment do
    Sheets::Counting::UniteAttacks.import_via_tweet
  end

  desc '「協力攻撃部門」のDM投票の開票データをスプレッドシートからインポートする'
  task exec_via_dm: :environment do
    # Sheets::Counting::UniteAttacks.import_via_dm
  end
end
