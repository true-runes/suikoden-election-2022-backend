source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'bootsnap', require: false
gem 'bugsnag'
gem 'dotenv-rails'
gem 'faraday', '2.3.0' # 'google-cloud-language' が使えるように
gem 'google-api-client'
gem 'google-cloud-language'
gem 'paper_trail'
gem 'pg'
gem 'puma'
gem 'rails'
gem 'twitter'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'factory_bot_rails'
end
