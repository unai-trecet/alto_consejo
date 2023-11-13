# frozen_string_literal: true

class FriendshipRequestMailer < ApplicationMailer
  default from: 'altoconsejo@gmail.com'

  def friendship_request_email
    @friendship = params[:friendship]
    @recipient = params[:recipient]
    @friendship_url = friendship_url(@friendship)

    mail(to: @recipient.email, subject: 'Tienes una solicitud de amistad!')
  end
end
