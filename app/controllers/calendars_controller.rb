class CalendarsController < ApplicationController

  def matches_calendar
    start_date = params.fetch(:start_date, Date.today).to_date
    @matches = current_user.participations.where(start_at: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end
end
