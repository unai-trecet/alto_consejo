# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_resource
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :render_not_found

  private

  def record_not_found(exception)
    @exception = exception
    render template: '/error_pages/not_found', status: 404
  end

  def render_internal_server_error(exception)
    @exception = exception
    render template: '/errors/404', status: 500
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
