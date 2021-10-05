# frozen_string_literal: true

class PasswordsController < ApplicationController
  before_action :require_user_logged_in!

  def edit; end

  def update
    if Current.user.update(password_params)
      redirect_to root_path, notice: 'Contraseña cambiada con éxito, Sire.'
    else
      flash[:alert] = 'La contraseña no pudo ser cambiada, Sire.'
      render :edit
    end
  end

  private

  def passwrod_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
