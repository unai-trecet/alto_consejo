# frozen_string_literal: true

module MatchesHelper
  def can_participate?
    @match.invited_users.include?(current_user.username)
  end

  def already_participating?
    @match.participants.include?(current_user)
  end

  def can_edit_match?
    @match.user == current_user || admin?
  end
end
