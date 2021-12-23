# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :welcome

  def welcome; end

  def dashboard
    @games = current_user.games
    @organised_matches = current_user.matches
    @played_participations = current_user.participations.played
    @not_played_participations = current_user.participations.not_played
    @notification = current_user.notifications
  end

  def autocomplete
    names = AutocompleteGameName.new(params[:q]).call
    render json: names
  end
end
