# frozen_string_literal: true

class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  # validate :sender_present?

  def type_name
    type.safe_constantize.human_name
  end

  def sender
    params[:sender]
  end

  def sender_username
    sender&.username
  end

  private

  def sender_present?
    return if params[:sender].present? && params[:sender].is_a?(User)

    errors.add('params[:sender]', I18n.t('activerecord.errors.models.notification.sender_not_present'))
  end
end
