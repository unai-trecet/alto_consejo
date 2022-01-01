# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'

gem 'active_model_serializers'
gem 'awesome_print'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'devise'
gem 'httparty'
# gem 'image_processing', '~> 1.2'
gem 'jbuilder', '~> 2.7'
gem 'kaminari'
gem 'mailcatcher'
gem 'noticed'
gem 'pg'
gem 'puma'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5.2.0'
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
  gem 'rack-mini-profiler', '~> 2.0'
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
  gem 'shoulda-matchers', '~> 5.0'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
