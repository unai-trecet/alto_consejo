class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = USer.new(user_params)

    if @user.save
      # stores user id in session
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Miembro del consejo aceptado.'
    else
      flash[:error] = 'La creación del miembro del Cnsejo ha sido denegada.'
      render :new
    emd
  end

  private

  def user_parmas
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end