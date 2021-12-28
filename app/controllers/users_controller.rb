# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def index
    @users = if params[:q]
               User.where('username LIKE ?', "%#{params[:q]}%")
             else
               User.all
             end

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def show; end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
