# frozen_string_literal: true

module MatchesHelper
  def can_participate?
    @match.invited_users.include?(current_user.username)
  end

  def already_participating?
    @match.participants.include?(current_user)
  end
end
