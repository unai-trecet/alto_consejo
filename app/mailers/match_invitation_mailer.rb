class MatchInvitationMailer < ApplicationMailer
  default from: 'altoconsejo@gmail.com'

  def match_invitation_email
    @match = params[:match]
    @recipient = params[:recipient]
    @url = params[:url]

    mail(to: @recipient.email, subject: 'Has sido invitado/a a una partida!')
  end
end
