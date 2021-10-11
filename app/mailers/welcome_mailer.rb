# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url = 'http://localhost:3000/sign_in'
    mail(to: @user.email, subject: 'Bienvenido, ocupe su sitio en el Alto Consejo Friki')
  end
end
