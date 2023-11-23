# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_resource
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    redirect_to root_path, notice: :not_found
  end

  def set_resource
    return unless params[:id]

    @resource = case controller_name
                when 'games'
                  Game.find(params[:id])
                when 'matches'
                  Match.find(params[:id])
                when 'users'
                  User.find(params[:id])
                when 'comments'
                  Comment.find(params[:id])
                end
  end
end
