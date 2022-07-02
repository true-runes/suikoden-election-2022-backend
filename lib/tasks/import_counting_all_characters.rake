namespace :import_unite_attacks do
  desc '「オールキャラ部門」の開票データをスプレッドシートからインポートする'
  task exec: :environment do
    Sheets::Counting::AllCharacters.import
  end
end
