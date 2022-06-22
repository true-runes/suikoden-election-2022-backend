require "google/cloud/language"

module NaturalLanguage
  # client は app/lib/cloud_language.rb を参照

  class Analyzer
    def self.save_analyze_syntax_record(client, tweet_or_dm)
      response = analyze_tweet_syntax_by_api(client, tweet_or_dm.content_text)

      ActiveRecord::Base.transaction do
        unique_attrs = {
          tweet_id: tweet_or_dm.instance_of?(Tweet) ? tweet_or_dm.id : nil,
          direct_message_id: tweet_or_dm.instance_of?(DirectMessage) ? tweet_or_dm.id : nil
        }

        attrs = {
          language: response.language,
          sentences: response.sentences.map(&:to_json),
          tokens: response.tokens.map(&:to_json),
          tweet_id: tweet_or_dm.instance_of?(Tweet) ? tweet_or_dm.id : nil,
          direct_message_id: tweet_or_dm.instance_of?(DirectMessage) ? tweet_or_dm.id : nil
        }

        AnalyzeSyntax.find_or_initialize_by(unique_attrs).update!(attrs)
      end
    end

    # save_analyze_syntax_record メソッド によって呼ばれる密結合なメソッド
    def self.analyze_tweet_syntax_by_api(client, text)
      document = { type: :PLAIN_TEXT, content: text }

      # analyze_syntax メソッドはライブラリに生えているメソッド
      client.analyze_syntax(document: document)
    end
  end
end
