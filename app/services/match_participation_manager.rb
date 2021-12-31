# frozen_string_literal: true

class MatchParticipationManager
  def initialize(user_id:, match_id:)
    @user = User.find(user_id)
    @match = Match.find(match_id)
  end

  def call
    ActiveRecord::Base.transaction do
      delete_invitation
      create_match_participation
      send_notifications
    end
  end

  private

  def delete_invitation
    return unless (invitation = MatchInvitation.find_by(user: @user, match: @match))

    invitation.delete
  end

  def create_match_participation
    @match_paticipant = MatchParticipant.create!(user: @user, match: @match)
  end

  def send_notifications
    recipients = @match.reload.participants.reject { |participant| participant == @user }
    MatchParticipationNotification.with(match: @match, player: @user)
                                  .deliver_later(recipients)
  end
end
