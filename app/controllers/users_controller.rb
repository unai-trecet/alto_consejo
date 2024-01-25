# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authorize_user
  before_action :set_user, only: %i[purge_avatar]
  before_action :require_permission, except: %i[show index username_search]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.includes(:played_games, :played_matches, avatar_attachment: :blob).page(params[:page])

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

  def purge_avatar
    unless is_user_curren_user?
      redirect_back_or_to(root_path,
                          notice: I18n.t('attachments.forbidden')) and return
    end

    @user.avatar.purge

    redirect_back_or_to root_path, notice: I18n.t('attachments.success')
  end

  private

  def user_params
    params.require(:user).permit(:username, :avatar)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_permission
    return if is_user_curren_user?

    redirect_to root_path, flash: { error: t('custom_errors.unauthorized') }
  end

  def is_user_curren_user?
    current_user == @user
  end
end
