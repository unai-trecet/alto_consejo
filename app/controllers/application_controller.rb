class ApplicationController < ActionController::Base
  include ActionView::RecordIdentifier

  before_action :authenticate_user!
  before_action :set_resource, only: %i[show destroy update edit]
  before_action :authorize_user, only: %i[destroy update edit]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :render_not_found

  private

  def record_not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def render_not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def set_resource
    resource = controller_name.classify.constantize.find(params[:id]) if params[:id]
    instance_variable_set("@#{controller_name.singularize}", resource)
    @resource = resource
  end

  def authorize_user
    return if @resource.user == current_user || current_user.admin?

    flash[:notice] = t('.error')
    redirect_to unauthorized_path
  end
end
