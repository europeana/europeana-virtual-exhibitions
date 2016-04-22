source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.2'

# Use puma webserver
gem 'puma', '~> 2.13'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'redis-rails'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'acts_as_list', '~> 0.7.4' # dependency of a dependency; version 0.7.3 yanked

group :production do
  gem 'rails_12factor', '~> 0.0.3'
end

gem 'rack-plastic'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'dotenv-rails', '~> 2.0'
  gem 'spring-commands-rspec'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rubocop', '0.35.1'
end

gem 'alchemy_cms', github: 'AlchemyCMS/alchemy_cms', branch: 'master'
gem 'alchemy-devise', github: 'AlchemyCMS/alchemy-devise', branch: 'master'

gem 'capistrano-alchemy', github: 'AlchemyCMS/capistrano-alchemy', branch: 'master', group: 'development'

# European styleguide
gem 'europeana-styleguide', github: 'europeana/europeana-styleguide-ruby', ref: 'dc6be01'
gem 'stache', github: 'europeana/stache', branch: 'europeana-styleguide' # until upstream merges our pull requests

gem 'dragonfly-swift_data_store', github: 'europeana/dragonfly-swift-data-store', tag: 'v0.1.0'

group :localeapp do
  gem 'localeapp', '~> 1.0'
end

gem 'delayed_job_active_record'

group :test do
  gem 'database_cleaner', '~> 1.3'
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails', '~> 4.5'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'simplecov', require: false
end

gem 'appsignal'
gem 'newrelic_rpm'
