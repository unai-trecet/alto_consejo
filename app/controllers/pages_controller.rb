# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :welcome

  def welcome; end

  def dashboard; end
end
