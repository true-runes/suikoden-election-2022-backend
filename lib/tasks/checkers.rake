# rubocop:disable Metrics/BlockLength
namespace :checkers do
  desc 'ローカルデータベースが対象の全てのチェッカを実行する'
  task in_db_data: :environment do
    # User 規定票数以上投票チェック
    over_three_votes_users = Counting::Checkers::AllCharacters.over_three_votes_users
    raise StandardError, "以下の User は規定票数以上の票を投票しています。\n#{over_three_votes_users.map(&:screen_name).join("\n")}" if over_three_votes_users.present?

    puts '[LOG] User 規定票数以上の投票をしていないかのチェックが終了しました。'

    # User 同キャラ投票チェック
    vote_to_the_same_characters_users = Counting::Checkers::AllCharacters.vote_to_the_same_characters_users
    raise StandardError, "以下の User は同じキャラに対して投票しています。\n#{vote_to_the_same_characters_users.map(&:screen_name).join("\n")}" if vote_to_the_same_characters_users.present?

    puts '[LOG] User 同キャラ投票をしていないかのチェックが終了しました。'

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

  desc '最終集計結果シートのチェッカを実行する'
  task in_final_sheets_data: :environment do
    excluded_names = Rails.application.credentials.excluded_not_in_db_character_names

    o = Sheets::WriteAndUpdate::FinalResults::UnitedAllCharacters.new
    bonus_op_cl_rows = o.bonus_op_cl_rows
    bonus_campaigns_rows = o.bonus_campaigns_rows
    bonus_result_illustrations_rows = o.bonus_result_illustrations_rows
    bonus_fav_quotes_rows = o.bonus_fav_quotes_rows
    bonus_short_stories_rows = o.bonus_short_stories_rows
    all_characters_division_rows = o.all_characters_rows

    # ボ・OP・CLイラスト（オールキャラ）
    bonus_op_cl_rows.pluck(:character_name).each do |name|
      next if name.in?(excluded_names)

      raise StandardError, "ボ・OP・CLイラスト（オールキャラ）: #{name} は キャラDB の中に存在しません。" unless Character.exists?(name: name)
    end
    puts '[LOG] 「ボ・OP・CLイラスト（オールキャラ）」の キャラDBチェック が終了しました。'

    # ボ・選挙運動
    bonus_campaigns_rows.pluck(:character_name).each do |name|
      next if name.in?(excluded_names)

      raise StandardError, "ボ・選挙運動: #{name} は キャラDB の中に存在しません。" unless Character.exists?(name: name)
    end
    puts '[LOG] 「ボ・選挙運動」の キャラDBチェック が終了しました。'

    # ボ・開票イラスト
    bonus_result_illustrations_rows.pluck(:character_name).each do |name|
      next if name.in?(excluded_names)

      raise StandardError, "ボ・開票イラスト: #{name} は キャラDB の中に存在しません。" unless Character.exists?(name: name)
    end
    puts '[LOG] 「ボ・開票イラスト」の キャラDBチェック が終了しました。'

    # ボ・推し台詞
    bonus_fav_quotes_rows.pluck(:character_name).each do |name|
      next if name.in?(excluded_names)

      raise StandardError, "ボ・推し台詞: #{name} は キャラDB の中に存在しません。" unless Character.exists?(name: name)
    end
    puts '[LOG] 「ボ・推し台詞」の キャラDBチェック が終了しました。'

    # ボ・お題小説
    bonus_short_stories_rows.pluck(:character_name).each do |name|
      next if name.in?(excluded_names)

      raise StandardError, "ボ・お題小説: #{name} は キャラDB の中に存在しません。" unless Character.exists?(name: name)
    end
    puts '[LOG] 「ボ・お題小説」の キャラDBチェック が終了しました。'

    # 単体・①オールキャラ部門
    all_characters_division_rows.pluck(:character_name).each do |name|
      next if name.in?(excluded_names)

      raise StandardError, "単体・①オールキャラ部門: #{name} は キャラDB の中に存在しません。" unless Character.exists?(name: name)
    end

    all_characters_division_rows.each do |row|
      # 開票イラストのあるなしチェック
      bonus_result_illustration = bonus_result_illustrations_rows.find { |r| r[:character_name] == row[:character_name] }

      raise StandardError, "単体・①オールキャラ部門: #{row[:character_name]} の開票イラストの「あるなし」のステータスがおかしいです。" if row[:result_illustration_exist] == 'TRUE' && bonus_result_illustration.blank?

      raise StandardError, "単体・①オールキャラ部門: #{row[:character_name]} の開票イラストの「あるなし」のステータスがおかしいです。" if row[:result_illustration_exist] == 'FALSE' && bonus_result_illustration.present?

      # 推し台詞のあるなしチェック
      bonus_fav_quote = bonus_fav_quotes_rows.find { |r| r[:character_name] == row[:character_name] }

      raise StandardError, "単体・①オールキャラ部門: #{row[:character_name]} の推し台詞の「あるなし」のステータスがおかしいです。" if row[:fav_quotes_exist] == 'TRUE' && bonus_fav_quote.blank?

      raise StandardError, "単体・①オールキャラ部門: #{row[:character_name]} の推し台詞の「あるなし」のステータスがおかしいです。" if row[:fav_quotes_exist] == 'FALSE' && bonus_fav_quote.present?
    end
    puts '[LOG] 「単体・①オールキャラ部門」のチェックが終了しました。'

    # 最終・①オールキャラ部門
    sheet_name = '最終・①オールキャラ部門'
    final_result_rows = SheetData.get_rows(sheet_id: ENV.fetch('COUNTING_FINAL_RESULTS_SHEET_ID', nil), range: "#{sheet_name}!B2:T501")

    # row[1] はキャラ名である
    final_result_rows.each do |row|
      row_content_to_number = {
        キャラ名: 1,
        ボ・OP・CLイラストの加算得票数: 5,
        ボ・選挙運動の加算得票数: 9,
        推しセリフがある？: 12,
        推し台詞がある場合、第一候補の台詞内容: 18
      }

      # OPCLイラストのあるなしチェック
      bonus_op_cl = bonus_op_cl_rows.find { |r| r[:character_name] == row[row_content_to_number[:キャラ名]] }

      # row[5] は「ボ・OP・CLイラスト」の加算得票数
      op_cl_number_of_votes = row[row_content_to_number[:ボ・OP・CLイラストの加算得票数]]
      raise StandardError, "最終・①オールキャラ部門: #{row[1]} のOP・CLイラストのステータスがおかしいです。" if op_cl_number_of_votes == 1 && bonus_op_cl.blank?
      raise StandardError, "最終・①オールキャラ部門: #{row[1]} のOP・CLイラストのステータスがおかしいです。" if op_cl_number_of_votes == 0 && bonus_op_cl.present?

      # 選挙運動のあるなしチェック
      bonus_campaign = bonus_campaigns_rows.find { |r| r[:character_name] == row[row_content_to_number[:キャラ名]] }

      # row[9] は「ボ・選挙運動」の加算得票数
      campaigns_number_of_votes = row[row_content_to_number[:ボ・選挙運動の加算得票数]]
      raise StandardError, "最終・①オールキャラ部門: #{row[1]} の選挙運動のステータスがおかしいです。" if campaigns_number_of_votes == 2 && bonus_campaign.blank?
      raise StandardError, "最終・①オールキャラ部門: #{row[1]} の選挙運動のステータスがおかしいです。" if campaigns_number_of_votes == 0 && bonus_campaign.present?

      # 推し台詞がある場合に台詞抽出がされているか、推し台詞がない場合には誤って抽出されてしまっていないか、のチェック
      fav_quote_exist = row[row_content_to_number[:推しセリフがある？]]
      fav_quote_contents = row[row_content_to_number[:推し台詞がある場合、第一候補の台詞内容]]
      raise StandardError, "最終・①オールキャラ部門: #{row[1]} の推し台詞と台詞抽出の内容がおかしいです。" if fav_quote_exist == 'TRUE' && fav_quote_contents.blank?
      raise StandardError, "最終・①オールキャラ部門: #{row[1]} の推し台詞と台詞抽出の内容がおかしいです。" if fav_quote_exist == 'FALSE' && fav_quote_contents.present?
    end
    puts '[LOG] 「最終・①オールキャラ部門」のチェックが終了しました。'
  end
end
# rubocop:enable Metrics/BlockLength
