# frozen_string_literal: true

# To deliver this notification:
#
# MatchInvitationNotification.with(post: @post).deliver_later(current_user)
# MatchInvitationNotification.with(post: @post).deliver(current_user)

class MatchInvitationNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: 'MatchInvitationMailer', method: :match_invitation_email
  # deliver_by :action_cable

  # Add required params
  #
  param :match

  # Define helper methods to make rendering easier.
  #
  def message
    t('.message', organizer: params[:match].user.username)
  end

  def url
    match_url(id: params[:match].id)
  end

  def self.human_name
    I18n.t('notifications.match_invitation_notification')
  end
end
