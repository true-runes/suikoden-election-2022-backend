namespace :import_counting_all_characters do
  desc '「オールキャラ部門」の開票データをスプレッドシートからインポートする'
  task exec: :environment do
    Sheets::Counting::AllCharacters.import
  end
end
