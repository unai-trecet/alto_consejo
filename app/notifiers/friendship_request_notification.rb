class FriendshipRequestNotification < Noticed::Event
  deliver_by :email, mailer: 'FriendshipRequestMailer', method: :friendship_request_email
  required_params :friendship, :sender

  def message
    t('.message', sender: params[:sender][:username])
  end

  def url
    friendship_url(params[:friendship])
  end
end