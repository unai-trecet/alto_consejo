# frozen_string_literal: true

class ErrorPagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'devise'

  def unauthorized
    render '403'
  end
end
