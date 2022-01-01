# frozen_string_literal: true

class MatchInvitationsManager
  def initialize(match:, creator_participates:)
    @match = match
    @invited_users = User.where(username: @match.invited_users)
    @creator_participates = creator_participates
  end

  def call
    ActiveRecord::Base.transaction do
      set_creator_as_participant if @creator_participates
      create_invitations
      send_invitations
    end
  end

  private

  def set_creator_as_participant
    MatchParticipant
      .first_or_create(user_id: @match.creator.id, match_id: @match.id)
  end

  def create_invitations
    result = MatchInvitation.insert_all(define_creation_params, returning: %w[user_id])
    @created_invitations_user_ids = result.rows.map(&:pop)
  end

  def define_creation_params
    @invited_users.map do |user|
      { user_id: user.id, match_id: @match.id }
    end
  end

  def send_invitations
    new_recipients = @invited_users.select { |user| @created_invitations_user_ids.include?(user.id) }
    MatchInvitationNotification
      .with(match: @match)
      .deliver_later(new_recipients)
  end
end
