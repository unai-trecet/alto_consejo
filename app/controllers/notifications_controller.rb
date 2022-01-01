# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[show edit update destroy]

  # GET /notifications or /notifications.json
  def index
    @notifications = current_user.notifications.page(params[:page])
  end

  # GET /notifications/1 or /notifications/1.json
  def show
    @notification.mark_as_read!
  end

  # DELETE /notifications/1 or /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    @notification = Notification.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def notification_params
    params.fetch(:notification, {})
  end
end
