class MatchParticipationNotification < Noticed::Event
  # Add your delivery methods
  #
  deliver_by :email, mailer: 'MatchParticipationMailer', method: :match_participation_email

  # Add required params
  #
  required_params :match, :player, :sender

  # Define helper methods to make rendering easier.
  #
  def message
    t('.message', player: required_params[:player].username)
  end

  def url
    match_path(required_params[:match])
  end
end
