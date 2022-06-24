namespace :import_unite_attacks do
  desc '「協力攻撃」のデータをスプレッドシートからインポートする'
  task exec: :environment do
    Sheets::UniteAttacks.all_importer
  end
end
