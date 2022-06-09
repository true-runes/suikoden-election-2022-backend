require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'

class SheetService
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = '幻水総選挙2022 バックエンド'.freeze
  CREDENTIALS_PATH = 'config/google_api_credentials.json'.freeze
  TOKEN_PATH = 'config/google_api_token.yml'.freeze
  SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

  attr_reader :service

  def initialize
    @service = Google::Apis::SheetsV4::SheetsService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  def authorize
    client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)

    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI)
      # rubocop:disable Rails/Output
      puts "Open the following URL in the browser and enter the resulting code after authorization:\n#{url}"
      # rubocop:enable Rails/Output
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id:, code:, base_url: OOB_URI
      )
    end

    credentials
  end
end
