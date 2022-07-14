namespace :checkers do
  desc 'ローカルデータベースが対象の全てのチェッカを実行する'
  task in_db_data: :environment do
    # User 規定票数以上投票チェック
    over_three_votes_users = Counting::Checkers::AllCharacters.over_three_votes_users
    raise StandardError, "以下の User は規定票数以上の票を投票しています。\n#{over_three_votes_users.map(&:screen_name).join("\n")}" if over_three_votes_users.present?

    puts '[LOG] 規定票数以上の投票をしていないかのチェックが終了しました。'

    # User 同キャラ投票チェック
    vote_to_the_same_characters_users = Counting::Checkers::AllCharacters.vote_to_the_same_characters_users
    raise StandardError, "以下の User は同じキャラに対して投票しています。\n#{vote_to_the_same_characters_users.map(&:screen_name).join("\n")}" if vote_to_the_same_characters_users.present?

    puts '[LOG] 同キャラ投票をしていないかのチェックが終了しました。'

    # DM データチェック
    not_good_rows = Counting::Checkers::DirectMessages.new.not_good_rows_if_same_vote_contents_exist
    raise StandardError, "シート上の以下の id の DM は不適切です。\n#{not_good_rows.map { |row| row[0]}.join("\n")}" if not_good_rows.present?

    puts '[LOG] シート上の DM のデータのチェックが終了しました。'

    # 開票イラストのキャラ名が DB に存在するかどうかをチェック
    imported_local_db_character_names = OnRawSheetResultIllustrationTotalling.all.pluck(:character_name_by_sheet_totalling)
    filtered_imported_local_db_character_names = imported_local_db_character_names.reject { |name| name.start_with?('TEMP_') }

    o = Counting::Checkers::ResultIllustrations.new

    filtered_imported_local_db_character_names.each do |character_name|
      raise StandardError, "#{character_name} は キャラDB の中に存在しません。" unless o.is_in_sheet_character_name_in_db?(character_name)
    end

    puts '[WARN] 開票イラストのキャラ名に "TEMP_" のデータが含まれています。' if imported_local_db_character_names.find { |name| name.start_with?('TEMP_') }
    puts '[LOG] 開票イラストのキャラ名が DB に存在するかどうかのチェックが終了しました'
  end

  desc '最終スプレッドシートが対象の全てのチェッカを実行する'
  task in_final_sheets_data: :environment do
    final_sheet_id = ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil)

    # キャラ名辞書一致
    # ボ・OP・CLイラスト（オールキャラ）
    # ボ・選挙運動
    # ボ・開票イラスト
    # ボ・推し台詞
    # ボ・お題小説

    # さらに、開票イラストあるなし、推し台詞あるなし
    # 単体・①オールキャラ部門

    # さらに、OPCLイラストあるなし、選挙運動あるなし
    # 最終・①オールキャラ部門
  end
end
