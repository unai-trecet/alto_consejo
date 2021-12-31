# frozen_string_literal: true

# To deliver this notification:
#
# MatchParticipationNotification.with(post: @post).deliver_later(current_user)
# MatchParticipationNotification.with(post: @post).deliver(current_user)

class MatchParticipationNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: 'MatchParticipationMailer', method: :match_participation_email

  # Add required params
  #
  param :match, :player

  # Define helper methods to make rendering easier.
  #
  def message
    t('.message')
  end

  def url
    post_path(params[:post])
  end
end
