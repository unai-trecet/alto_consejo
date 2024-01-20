# frozen_string_literal: true

module GamesHelper
  def can_edit_game?
    @game.user == current_user || admin?
  end
end
