# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    redirect_to root_path, notice: :not_found
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
   end

end
