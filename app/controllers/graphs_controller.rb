class GraphsController < ApplicationController
  def user_played_matches
    render json: current_user
      .played_matches
      .group_by_day(:end_at, range: from_date..DateTime.now)
      .count
  end

  def user_organized_matches
    render json: current_user
      .matches
      .group_by_day(:created_at, range: from_date..DateTime.now)
      .count
  end

  private

  def from_date
    if params[:from_date]
      date_from_params
    else
      1.month.ago
    end
  end

  def date_from_params
    case params[:from_date]
    when 'last_week'
      1.week.ago
    when 'last_month'
      1.month.ago
    when 'last_three_months'
      3.months.ago
    when 'last_six_months'
      6.months.ago
    when 'last_year'
      1.year.ago
    else
      1.month.ago
    end
  end
end
