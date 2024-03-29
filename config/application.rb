# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AltoConsejo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.action_mailer.preview_paths = ["#{Rails.root}/spec/mailers/previews"]
    config.generators do |g|
      g.test_framework :rspec
    end

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}')]
    config.i18n.available_locales = %i[en es]
    config.i18n.default_locale = :es

    config.exceptions_app = routes
  end
end
