# frozen_string_literal: true

class MatchInvitationsManager
  def initialize(invited_usernames:, match:, creator_id: nil)
    @creator = User.find_by(id: creator_id)
    @invited_users = User.where(username: invited_usernames)
    @match = match
  end

  def call
    ActiveRecord::Base.transaction do
      set_creator_as_participant if @creator
      create_invitations
      send_invitations
    end
  end

  private

  def set_creator_as_participant
    MatchParticipant
      .first_or_create(user_id: @creator.id, match_id: @match.id)
  end

  def create_invitations
    MatchInvitation.insert_all(define_creation_params)
  end

  def define_creation_params
    @invited_users.map do |user|
      { user_id: user.id, match_id: @match.id }
    end
  end

  def send_invitations
    MatchInvitationNotification
      .with(match: @match)
      .deliver_later(@invited_users)
  end
end
