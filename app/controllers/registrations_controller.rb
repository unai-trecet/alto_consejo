# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      WelcomeMailer.with(user: @user).welcome_email.deliver_now
      # stores user id in session
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Miembro del consejo aceptado.'
    else
      flash[:error] = 'La creación del miembro del Cnsejo ha sido denegada.'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
