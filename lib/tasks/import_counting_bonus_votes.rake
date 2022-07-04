namespace :import_counting_bonus_votes do
  desc '「ボーナス票」の各対象ツイートの開票データをスプレッドシートからインポートする'
  task exec_via_tweet: :environment do
    Sheets::Counting::BonusVotes.import_via_tweet
  end

  desc '「ボーナス票」の各対象DM投票の開票データをスプレッドシートからインポートする'
  task exec_via_dm: :environment do
    Sheets::Counting::BonusVotes.import_via_dm
  end

  desc '「ボーナス票」の各対象ツイートおよびDM投票の開票データをスプレッドシートからインポートする'
  task exec_all: :environment do
    Sheets::Counting::BonusVotes.import_via_tweet
    Sheets::Counting::BonusVotes.import_via_dm
  end
end
