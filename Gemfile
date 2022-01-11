# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'
gem 'rails', '~> 7.0.0'

# gem 'active_model_serializers'
gem 'awesome_print'
gem 'bcrypt'
# gem 'bootsnap', require: false
gem 'devise'
gem 'httparty'
# gem 'image_processing', '~> 1.2'
gem 'jbuilder', '~> 2.7'
gem 'kaminari'
gem 'mailcatcher'
gem 'noticed'
gem 'pg'
gem 'puma'
gem 'ransack'
gem 'sass-rails', '>= 6'
gem 'simple_calendar'
# gem 'turbolinks'
gem 'turbo-rails'
gem 'webpacker'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'timecop'
end

group :development do
  gem 'brakeman'
  gem 'rack-mini-profiler'
  gem 'rubocop'
  gem 'solargraph'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'database_cleaner-active_record'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Use Redis for Action Cable
gem 'redis', '~> 4.0'
