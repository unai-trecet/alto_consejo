# frozen_string_literal: true

class AttachmentsController < ApplicationController
  skip_before_action :authorize_user, :set_resource
  before_action :set_attachment

  def purge
    redirect_back fallback_location: root_path, notice: I18n.t('attachments.forbidden') and return unless can_be_purged?

    @attachment.purge

    redirect_back fallback_location: root_path, notice: I18n.t('attachments.success')
  end

  private

  def set_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def can_be_purged?
    @attachment.record.respond_to?(:user) && (@attachment.record.user == current_user || current_user.admin?)
  end
end
