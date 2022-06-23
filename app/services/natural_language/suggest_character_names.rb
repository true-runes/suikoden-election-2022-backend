module NaturalLanguage
  class SuggestCharacterNames
    def self.exec(tweet_or_dm)
      analyze_syntax = tweet_or_dm.analyze_syntax

      PickupCharacterNames.exec(analyze_syntax)
    end
  end
end
