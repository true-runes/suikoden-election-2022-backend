class CloudLanguage
  def self.client(credentials_path: nil)
    Google::Cloud::Language.language_service do |config|
      config.credentials = credentials_path || ENV.fetch('CLOUD_LANGUAGE_CREDENTIALS_PATH')
    end
  end
end
