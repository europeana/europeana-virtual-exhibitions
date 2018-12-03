source 'https://rubygems.org'

gem 'rails', '4.2.11'

gem 'alchemy-devise'
gem 'alchemy_cms'
gem 'clockwork'
gem 'coffee-rails'
gem 'country_select'
gem 'delayed_job_active_record'
gem 'dragonfly-s3_data_store'
gem 'dragonfly-swift_data_store', git: 'https://github.com/europeana/dragonfly-swift-data-store.git', tag: 'v0.1.0'
gem 'europeana-feedback-button', '0.0.7', require: 'europeana/feedback_button'
gem 'europeana-feeds'
gem 'europeana-i18n', git: 'https://github.com/europeana/europeana-i18n-ruby.git', branch: 'develop'
gem 'europeana-styleguide', git: 'https://github.com/europeana/europeana-styleguide-ruby.git', branch: 'develop'
gem 'jbuilder'
gem 'jquery-rails'
gem 'mail'
gem 'nokogiri'
gem 'pg', '~> 0.18'
gem 'puma'
gem 'rack-plastic'
gem 'rails_with_relative_url_root'
gem 'redis-rails'
gem 'rest-client'
gem 'sass-rails'
gem 'stache', git: 'https://github.com/europeana/stache.git', branch: 'europeana-styleguide' # until upstream merges our pull requests
gem 'therubyracer', platforms: :ruby
gem 'turbolinks'
gem 'uglifier'

group :profiling do
  gem 'stackprof'
end

group :production do
  gem 'rails_12factor'
  gem 'europeana-logging'
end

group :production, :development, :profiling do
  gem 'newrelic_rpm'
end

group :development, :test, :profiling do
  gem 'dotenv-rails'
  gem 'rubocop', '0.54', require: false
  gem 'spring-commands-rspec'
end

group :development do
  gem 'web-console'
  gem 'byebug'
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'geckodriver-helper'
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

group :localeapp do
  gem 'localeapp'
end

group :doc do
  gem 'sdoc'
end
