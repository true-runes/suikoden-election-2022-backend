module NaturalLanguage
  class SuggestCharacterNames
    def self.exec(tweet_or_dm)
      analyze_syntax = tweet_or_dm&.analyze_syntax

      return ['解析が未実行です'] if analyze_syntax.blank?

      PickupCharacterNames.exec(analyze_syntax)
    end
  end
end
