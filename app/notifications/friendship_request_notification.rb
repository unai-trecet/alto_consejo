# frozen_string_literal: true

# To deliver this notification:
#
# FriendshipRequestNotification.with(post: @post).deliver_later(current_user)
# FriendshipRequestNotification.with(post: @post).deliver(current_user)

class FriendshipRequestNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: 'FriendshipRequestMailer', method: :friendship_request_email

  # Add required params
  #
  param :friendship

  # Define helper methods to make rendering easier.
  #
  def message
    t('.message')
  end

  def url
    post_path(params[:post])
  end
end
