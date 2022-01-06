# frozen_string_literal: true

class ErrorPagesController < ApplicationController
  skip_before_action :authenticate_user!

  def unauthorized
    render '403'
  end
end
