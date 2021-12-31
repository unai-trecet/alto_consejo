# frozen_string_literal: true

class MatchParticipantsController < ApplicationController
  before_action :set_match_participant, only: :destroy
  skip_forgery_protection(only: :create)

  def create
    result = MatchParticipationManager
             .new(user_id: params[:user_id], match_id: params[:match_id])
             .call

    respond_to do |format|
      if (participation = result[:participation])
        format.html { redirect_to match_path(participation.match), notice: t('.created') }
        format.json { render :show, status: :created, location: participation.match }
      else
        format.html { redirect_to root_path, notice: result[:errors] }
        format.json { render json: result[:errors], status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if current_user == @match_participant.user || current_user == @match_participant.match_creator
      @match_participant.destroy

      head :no_content
    else
      head :unauthorized
    end
  end

  private

  def set_match_participant
    @match_participant = MatchParticipant.find(params[:id])
  end

  def match_participant_params
    params.permit(:user_id, :match_id)
  end
end
