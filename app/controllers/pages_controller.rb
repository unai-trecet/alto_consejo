# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :welcome

  def welcome; end

  def dashboard; end

  def autocomplete
    names = AutocompleteGameName.new(params[:q]).call
    render json: { names: names }
  end
end
