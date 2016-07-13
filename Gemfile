source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'

gem 'acts_as_list', '~> 0.7.4' # dependency of a dependency; version 0.7.3 yanked
gem 'alchemy-devise', git: 'https://github.com/AlchemyCMS/alchemy-devise', ref: '8c0a1e26'
gem 'alchemy_cms', git: 'https://github.com/AlchemyCMS/alchemy_cms', ref: '2365f502'
gem 'coffee-rails', '~> 4.1.0'
gem 'country_select'
gem 'delayed_job_active_record'
gem 'dragonfly-swift_data_store', github: 'europeana/dragonfly-swift-data-store', tag: 'v0.1.0'
gem 'europeana-styleguide', github: 'europeana/europeana-styleguide-ruby', ref: 'a413be1'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'nokogiri', '>= 1.6.8' # Forced update for security issues
gem 'pg', '~> 0.15'
gem 'rack-plastic'
gem 'redis-rails'
gem 'rest-client', '>= 1.8.0' # Forced update for security issues
gem 'sass-rails', '~> 5.0'
gem 'stache', github: 'europeana/stache', branch: 'europeana-styleguide' # until upstream merges our pull requests
gem 'therubyracer', platforms: :ruby
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'

group :production do
  gem 'rails_12factor', '~> 0.0.3'
end

group :production, :development do
  gem 'newrelic_rpm'
end

gem 'puma', '~> 2.13'

group :development, :test do
  gem 'dotenv-rails', '~> 2.0'
  gem 'spring-commands-rspec'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'byebug'
  gem 'spring'
end

group :test do
  gem 'database_cleaner', '~> 1.3'
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails', '~> 4.5'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'simplecov', require: false
end

group :localeapp do
  gem 'localeapp', '~> 1.0'
end

group :doc do
  gem 'sdoc', '~> 0.4.0'
end
