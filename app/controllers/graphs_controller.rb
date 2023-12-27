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
      DateTime.parse(params[:from_date])
    else
      3.months.ago
    end
  end
end
