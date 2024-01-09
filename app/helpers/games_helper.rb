# frozen_string_literal: true

module GamesHelper
  def can_edit_game?
    @game.added_by == current_user || admin?
  end
end
