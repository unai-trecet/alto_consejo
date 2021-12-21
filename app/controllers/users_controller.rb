# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = if params[:q]
               User.where('username LIKE ?', "%#{params[:q]}%")
             else
               User.all
             end

    render json: @users
  end
end
