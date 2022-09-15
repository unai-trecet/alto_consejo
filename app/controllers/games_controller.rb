# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update destroy purge_main_image]
  before_action :require_permission, only: %i[edit update destroy purge_main_image]

  # GET /games or /games.json
  def index
    @q = Game.ransack(params[:q])
    @games = @q.result.includes(:user, :played_matches).all.page(params[:page])
  end

  # GET /games/1 or /games/1.json
  def show; end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit; end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /search_game_name
  def search_game_name
    @search_results = AutocompleteGameName.new(params['q']).call
    render partial: 'shared/autocomplete', layout: false
  end

  # DELETE /games/:id/purge_main_image
  def purge_main_image
    unless current_user_creator?
      redirect_back_or_to(root_path,
                          notice: I18n.t('attachments.forbidden')) and return
    end

    @game.main_image.purge

    redirect_back_or_to root_path, notice: I18n.t('attachments.success')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  def require_permission
    return if current_user_creator?

    redirect_to unauthorized_path
  end

  def current_user_creator?
    current_user == @game.added_by
  end

  # Only allow a list of trusted parameters through.
  def game_params
    params.require(:game).permit(:name, :description, :author, :user_id, :bbg_link, :main_image, :game_pictures)
  end
end
