# frozen_string_literal: true

class MatchParticipationMailer < ApplicationMailer
  default from: 'altoconsejo@gmail.com'

  def match_participation_email
    @match = params[:match]
    @player = params[:player]
    @url = match_url(@match)
    @recipient = params[:recipient]

    mail(to: @recipient.email, subject: default_i18n_subject(player: @player.username))
  end
end
