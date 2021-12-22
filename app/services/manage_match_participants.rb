# frozen_string_literal: true

class ManageMatchParticipants
  def initialize(invited_usernames:, match:, creator_id: nil)
    @creator = User.find_by(id: creator_id)
    @invited_usernames = invited_usernames
    @match = match
  end

  def call
    set_creator_as_participant if @creator
    send_invitations
  end

  private

  def send_invitations
    MatchInvitationNotification
      .with(match: @match)
      .deliver_later(User.where(username: @invited_usernames))
  end

  def set_creator_as_participant
    MatchParticipant
      .create(user_id: @creator.id, match_id: @match.id)
  end
end
