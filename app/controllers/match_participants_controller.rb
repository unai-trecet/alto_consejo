class MatchParticipantsController < ApplicationController
  before_action :set_match_participant, only: :destroy

  def create
    @match_paticipant = MatchParticipant.new(match_participant_params)

    if @match_paticipant.save
      render json: { match_participant: @match_paticipant, status: :created }
    else
      render json: @match_paticipant.errors, status: :unprocessable_entity
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
