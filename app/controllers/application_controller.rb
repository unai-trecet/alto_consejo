# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_current_user

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_user_logged_in!
    if Current.user.nil?
      redirect_to :sign_in_path,
                  alert: 'Para acceder, debe identificarse como un miembro del Consejo'
    end
  end
end
