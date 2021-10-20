# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:email])
    PasswordMailer.with(user: @user).reset.deliver_later

    redirect_to root_path, notice: 'Mire por favor su correo para reestablecer su contraseña.'
  end

  def edit
    @user = User.find_signed!(params[:token], purpose: 'password_reset')
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to sign_in_path, alert: 'Su token ha expirado. Por favor inténtelo otra vez, Sire.'
  end

  def update
    @user = User.find_signed!(params[:token], purpose: 'password_reset')

    if @user.update(password_params)
      redirect_to sign_in_path, notice: 'Su contraeña se ha reestablecido correctamente, Sire.'
    else
      flash[:alert] = 'Ha habido un error, Sire. Trate de escribir la misma contraseña.'
      render :edit
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to sign_in_path, alert: 'Su token ha expirado. Por favor inténtelo otra vez, Sire.'
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
