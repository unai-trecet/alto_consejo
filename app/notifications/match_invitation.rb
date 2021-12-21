# frozen_string_literal: true

# To deliver this notification:
#
# MatchInvitacion.with(post: @post).deliver_later(current_user)
# MatchInvitacion.with(post: @post).deliver(current_user)

class MatchInvitation < Noticed::Base
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
    t('.message')
  end

  def url
    match_path(params[:match])
  end
end
