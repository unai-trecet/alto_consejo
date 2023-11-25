class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html { render template: 'error_pages/404', status: 404 }
      format.json { render json: { error: 'Not found' }, status: 404 }
    end
  end

  def internal_server_error
    respond_to do |format|
      format.html { render template: 'error_pages/500', status: 500 }
      format.json { render json: { error: 'Internal server error' }, status: 500 }
    end
  end
end
