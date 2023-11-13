# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Set the default host and port to be the same as Action Mailer.
AltoConsejo::Application.default_url_options = AltoConsejo::Application.config.action_mailer.default_url_options

Rails.application.configure do
  config.secret_key_base = Rails.application.credentials.secret_key_base
end
