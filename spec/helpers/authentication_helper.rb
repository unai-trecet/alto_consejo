# frozen_string_literal: true

module Helpers
  module AuthenticationHelper
    def sign_in_user(user = nil)
      user ||= create(:user)
      post sign_in_url(email: user.email, password: user.password)
    end
  end
end
