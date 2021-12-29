# frozen_string_literal: true

class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]
  before_action :require_permission, only: %i[edit update destroy]

  # GET /matches or /matches.json
  def index
    @matches = Match.all
  end

  # GET /matches/1 or /matches/1.json
  def show; end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit; end

  # POST /matches or /matches.json
  def create
    @match = Match.new(match_params)

    respond_to do |format|
      if @match.save
        ManageMatchParticipants.new(
          creator_id: params['match']['creator_participates'],
          invited_usernames: @match.invited_users,
          match: @match
        ).call

        format.html { redirect_to @match, notice: t('.created') }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1 or /matches/1.json
  def update
    previous_invited_users = @match.invited_users

    respond_to do |format|
      if @match.update(match_params)
        ManageMatchParticipants.new(
          creator_id: params['match']['creator_participates'],
          invited_usernames: @match.invited_users - previous_invited_users,
          match: @match
        ).call

        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1 or /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = Match.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def match_params
    permited_params = params.require(:match).permit(:title, :description, :user_id, :game_id,
                                                    :location, :number_of_players, :start_at,
                                                    :end_at, :public, :invited_users)
    permited_params[:invited_users] = usernames
    permited_params
  end

  def usernames
    params['match']['invited_users']&.gsub('@', '')&.split
  end

  def require_permission
    return if current_user == @match.creator

    redirect_to root_path, flash: { error: t('custom_errors.unauthorized') }
  end
end
