class AdminsController < ApplicationController
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    return if current_user.is_a?(Admin)

    redirect_to welcome_path, alert: 'You are not authorized to view this page.'
  end
end
