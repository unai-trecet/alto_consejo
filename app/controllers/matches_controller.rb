# frozen_string_literal: true

class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]
  before_action :require_permission, only: %i[edit update destroy]

  # GET /matches or /matches.json
  def index
    @q = Match.filter(filtering_params)
              .eager_load(:user, :game, :participants)
              .ransack(name_cont: params[:q])
    @matches = @q.result.page(params[:page])
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
        if params['match']['creator_participates']
          MatchParticipationManager.new(match_id: @match.id,
                                        user_id: @match.creator.id).call
        end
        MatchInvitationsManager.new(match: @match).call

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
    respond_to do |format|
      if @match.update(match_params)
        if params['match']['creator_participates']
          MatchParticipationManager.new(match_id: @match.id,
                                        user_id: @match_id.creator.id).call
        end
        MatchInvitationsManager.new(match: @match).call

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

  def set_match
    @match = Match.find(params[:id])
  end

  def filtering_params
    filter = params.slice(*Match.filter_scopes)
    filter.present? ? filter : { all_by_user: current_user.id }
  end

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
