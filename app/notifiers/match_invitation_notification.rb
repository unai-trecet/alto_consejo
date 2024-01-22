class MatchInvitationNotification < Noticed::Event
  deliver_by :email, mailer: 'MatchInvitationMailer', method: :match_invitation_email
  required_params :match, :sender

  def message
    t('.message', organizer: params[:match].user.username)
  end

  def url
    match_url(id: params[:match].id)
  end

  def self.human_name
    I18n.t('notifications.match_invitation_notification.name')
  end

  def sender
    params[:sender]
  end

  def sender_username
    sender.username
  end
end
