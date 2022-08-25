# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :welcome
  layout 'devise', only: [:welcome]

  def welcome; end

  def dashboard
    @games = current_user.games
    @organised_matches = current_user.matches
    @played_participations = current_user.participations.played
    @not_played_participations = current_user.participations.not_played
    @notification = current_user.notifications
  end
end
