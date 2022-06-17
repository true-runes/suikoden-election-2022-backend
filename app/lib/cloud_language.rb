# c = CloudLanguage.client; document = { type: :PLAIN_TEXT, content: '吾輩は猫である。名前はまだ無い。' }
# result = c.analyze_syntax(document: document)
# result.tokens.size
# result.tokens[1]

class CloudLanguage
  def self.client(credentials_path: nil)
    Google::Cloud::Language.language_service do |config|
      config.credentials = credentials_path || ENV.fetch('CLOUD_LANGUAGE_CREDENTIALS_PATH')
    end
  end
end
