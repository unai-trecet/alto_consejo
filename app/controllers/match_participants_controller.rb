# frozen_string_literal: true

class MatchParticipantsController < ApplicationController
  before_action :set_match_participant, only: :destroy
  skip_forgery_protection(only: :create)

  def create
    @match_paticipant = MatchParticipant.new(match_participant_params)
    respond_to do |format|
      if @match_paticipant.save
        format.html { redirect_to match_path(@match_paticipant.match), notice: 'Te has inscrito con éxito en la partida!' }
        format.json { render :show, status: :created, location: @match_paticipant.game }
      else
        format.html { redirect_toredirect_to root_path, status: :unprocessable_entity }
        format.json { render json: @match_paticipant.errors, status: :unprocessable_entity }
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
