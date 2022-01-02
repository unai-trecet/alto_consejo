# frozen_string_literal: true

class MatchParticipationManager
  attr_reader :errors

  def initialize(user_id:, match_id:)
    @user = User.find(user_id)
    @match = Match.find(match_id)
    @match_paticipant = nil
    @result = { participation: nil, errors: [] }
  end

  def call
    ActiveRecord::Base.transaction do
      delete_invitation
      create_match_participation
      send_notifications
    end

    @result[:participation] = @match_paticipant
    @result
  rescue ActiveRecord::ActiveRecordError => e
    fill_error(e.message)
  rescue Noticed::ValidationError
    fill_error('Noticed::ValidationError')
  rescue Noticed::ResponseUnsuccessful
    fill_error('Noticed::ResponseUnsuccessful')
  rescue StandardError => e
    fill_error(e.message)
  end

  private

  def delete_invitation
    return unless (invitation = MatchInvitation.find_by(user: @user, match: @match))

    invitation.delete
  end

  def create_match_participation
    @match_paticipant = MatchParticipant.find_or_create_by!(user_id: @user.id, match_id: @match.id)
  end

  def send_notifications
    recipients = @match.reload.participants.reject { |participant| participant == @user }
    MatchParticipationNotification.with(match: @match, player: @user)
                                  .deliver_later(recipients)
  end

  def fill_error(message)
    Rails.logger.debug(message + I18n.t('services.errors.match_participation_manager_sufix', user_id: @user.id,
                                                                                             match_id: @match.id))
    @result[:errors].push(message)
    @result
  end
end
