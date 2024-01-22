class MatchParticipationManager
  attr_reader :player, :match, :result

  def initialize(user_id:, match_id:)
    @player = User.find(user_id)
    @match = Match.find(match_id)
    @result = { participation: nil, errors: [] }
  end

  def call
    @result[:participation] = manage_participation
    result
  rescue ActiveRecord::ActiveRecordError, Noticed::ValidationError, Noticed::ResponseUnsuccessful => e
    fill_error(e.message)
  rescue StandardError => e
    fill_error(e.message)
    raise e if Rails.env.development?
  end

  private

  def manage_participation
    ActiveRecord::Base.transaction do
      delete_invitation
      participation = create_match_participation
      send_notifications
      participation
    end
  end

  def delete_invitation
    invitation = MatchInvitation.find_by(user: player, match:)
    invitation&.destroy
  end

  def create_match_participation
    MatchParticipant.find_or_create_by!(user_id: player.id, match_id: match.id)
  end

  def send_notifications
    recipients = match.reload.participants.reject { |participant| participant == player }
    MatchParticipationNotification.with(match:, player:, sender: player)
                                  .deliver(recipients)
  end

  def fill_error(message)
    Rails.logger.debug(message + I18n.t('services.errors.match_participation_manager_sufix', user_id: player.id,
                                                                                             match_id: match.id))
    result[:errors].push(message)
    result
  end
end
