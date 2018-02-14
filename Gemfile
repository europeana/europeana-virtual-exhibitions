source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.9'

gem 'acts_as_list', '~> 0.7.4' # dependency of a dependency; version 0.7.3 yanked
gem 'alchemy-devise', git: 'https://github.com/AlchemyCMS/alchemy-devise', ref: '8c0a1e26'
gem 'alchemy_cms', '~> 3.3.0'
gem 'clockwork', '~> 1.2'
gem 'coffee-rails', '~> 4.1.0'
gem 'country_select'
gem 'delayed_job_active_record'
gem 'dragonfly-s3_data_store'
gem 'dragonfly-swift_data_store', github: 'europeana/dragonfly-swift-data-store', tag: 'v0.1.0'
gem 'europeana-styleguide', github: 'europeana/europeana-styleguide-ruby', branch: 'develop'
gem 'europeana-i18n', github: 'europeana/europeana-i18n-ruby', branch: 'develop'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'mail', '2.6.6.rc1' # locked pending stable release with fix for https://github.com/mikel/mail/pull/1097
gem 'nokogiri'
gem 'pg', '~> 0.21'
gem 'puma', '~> 3.10'
gem 'rack-plastic'
gem 'rails_with_relative_url_root', '~> 0.1'
gem 'redis-rails'
gem 'rest-client', '>= 1.8.0' # Forced update for security issues
gem 'sass-rails', '~> 5.0'
gem 'stache', github: 'europeana/stache', branch: 'europeana-styleguide' # until upstream merges our pull requests
gem 'therubyracer', platforms: :ruby
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'europeana-feedback-button', '0.0.5'
gem 'europeana-feeds', '0.0.2'

group :profiling do
  gem 'stackprof'
end


group :production do
  gem 'rails_12factor', '~> 0.0.3'
  gem 'europeana-logging', '~> 0.1.1'
end

group :production, :development, :profiling do
  gem 'newrelic_rpm'
end

group :development, :test, :profiling do
  gem 'dotenv-rails', '~> 2.0'
  gem 'rubocop', require: false
  gem 'spring-commands-rspec'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'byebug'
  gem 'spring'
end

group :test do
  gem 'capybara', '~> 2.4'
  gem 'database_cleaner', '~> 1.3'
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'shoulda-matchers', '~> 2.5.0'
  gem 'simplecov', require: false
  gem 'selenium-webdriver'
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'poltergeist'
end

group :localeapp do
  gem 'localeapp', '~> 1.0'
end

group :doc do
  gem 'sdoc', '~> 0.4.0'
end
