# frozen_string_literal: true

module Helpers
  module AuthenticationHelper
    def sign_in_user(user = nil)
      password = '12345678'
      user ||= User.create(email: 'test1@test.com', password: password, password_confirmation: password)
      post sign_in_url(email: user.email, password: user.password)
    end
  end
end
