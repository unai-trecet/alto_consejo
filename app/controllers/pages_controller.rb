# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :welcome
  layout 'devise', only: [:welcome]

  def welcome; end

  def dashboard
    feed_composer = UserFeedComposer.new(current_user)
    @dashboard_data = feed_composer.call.data
  end
end
