namespace :save_favorites do
  desc 'リアルタイムレポートのデータベースのデータを更新する'
  task continuous: :environment do
    Tweets::RetrieveFavorites.continuous

    '[DONE] ふぁぼ の継続保存が完了しました'
  end
end
