namespace :import_counting_all_characters do
  desc '「オールキャラ部門」のツイート投票の開票データをスプレッドシートからインポートする'
  task exec_via_tweet: :environment do
    Sheets::Counting::AllCharacters.import_via_tweet
  end

  desc '「オールキャラ部門」のDM投票の開票データをスプレッドシートからインポートする'
  task exec_via_dm: :environment do
    Sheets::Counting::AllCharacters.import_via_dm
  end

  desc '「オールキャラ部門」のツイートとDMの両方の開票データをスプレッドシートからインポートする'
  task exec_all: :environment do
    Sheets::Counting::AllCharacters.import_via_tweet
    Sheets::Counting::AllCharacters.import_via_dm
  end
end
