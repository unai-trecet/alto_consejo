# frozen_string_literal: true

class CalendarsController < ApplicationController
  def matches_calendar
    start_date = params.fetch(:start_date, Date.today).to_date
    @matches = Match.related_to_user(current_user.id)
                    .where(start_at: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
                    .uniq
  end
end
