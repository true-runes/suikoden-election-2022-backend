class PickupCharacterNames
  def self.exec(tweet_or_dm)
    check_words = tweet_or_dm.analyze_syntax&.check_words

    # Analayze をしてないレコード（アソシエーションとなる AnalyzeSyntax のレコードが存在しないレコード）のときは実行できない
    return if check_words.nil?

    character_candidate_names = []

    check_words.each do |check_word|
      next if skip_word?(check_word)

      # 部分一致の場合
      result_gensosenkyo_names = Character.joins(:nicknames).where('nicknames.name LIKE ?', "%#{check_word}%").map(&:name).uniq

      character_candidate_names += result_gensosenkyo_names
    end

    character_candidate_names.uniq
  end

  def self.skip_word?(word)
    skip_words = YAML.load_file(
      Rails.root.join("config/natural_language/skipped_check_words.yml")
    )['words'].uniq

    return true if word.in?(skip_words)

    false
  end
end
