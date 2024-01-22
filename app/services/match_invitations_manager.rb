# frozen_string_literal: true

class MatchInvitationsManager
  def initialize(match:, sender:)
    @match = match
    @sender = sender
    @invited_users = User.where(username: @match.invited_users)
  end

  def call
    return if @invited_users.blank?

    ActiveRecord::Base.transaction do
      create_invitations
      send_invitations
    end
  end

  private

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
      .with(match: @match, sender: @sender)
      .deliver(new_recipients)
  end
end
