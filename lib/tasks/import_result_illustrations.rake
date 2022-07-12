namespace :import_result_illustrations do
  desc '「開票イラスト」のデータをスプレッドシートからインポートする'
  task exec: :environment do
    puts Sheets::ResultIllustrationApplications.import_totallings_data_to_database

    # 開票イラストのシート上のキャラ名がキャラDBに存在するかどうかをチェックする（例外的な名前はチェックがスキップされる）
    imported_local_db_character_names = OnRawSheetResultIllustrationTotalling.all.pluck(:character_name_by_sheet_totalling)
    filtered_imported_local_db_character_names = imported_local_db_character_names.reject { |name| name.start_with?('TEMP_') }

    o = Counting::Checkers::ResultIllustrations.new

    filtered_imported_local_db_character_names.each do |character_name|
      raise StandardError, "#{character_name} は キャラDB の中に存在しません。" unless o.is_in_sheet_character_name_in_db?(character_name)
    end

    puts '[WARN] "TEMP_" のデータが含まれています。' if imported_local_db_character_names.find { |name| name.start_with?('TEMP_') }
    puts '[LOG] 開票イラストのデータをインポートしました。'
  end
end
