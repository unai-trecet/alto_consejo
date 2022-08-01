# frozen_string_literal: true

class MatchInvitationMailer < ApplicationMailer
  default from: 'altoconsejo@gmail.com'

  def match_invitation_email
    @match = params[:match]
    @recipient = params[:recipient]
    @url = match_participants_url(match_id: params[:match].id, user_id: @recipient.id)

    mail(to: @recipient.email, subject: 'Has sido invitado/a a una partida!')
  end
end
