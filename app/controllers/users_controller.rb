# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  before_action :require_permission, except: %i[show index username_search]

  def index
    @q = User.includes(:games, :matches, :played_matches).ransack(username_or_email_cont: params[:q])
    @users = @q.result(distinct: true).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: t('user_changed') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def username_search
    @q = User.ransack(username_cont: params[:q])
    @search_results = @q.result.map(&:username).take(10)

    render partial: 'shared/autocomplete', layout: false
  end

  private

  def user_params
    params.require(:user).permit(:username, :avatar)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_permission
    return if current_user == @user

    redirect_to root_path, flash: { error: t('custom_errors.unauthorized') }
  end
end
