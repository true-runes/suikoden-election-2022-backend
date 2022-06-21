require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

module SuikodenElection2022Backend
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
    config.time_zone = 'Tokyo'
    # created_at や updated_at は UTC で統一すべきと考えるので、以下の行は不要
    # config.active_record.default_timezone = :local
  end
end
