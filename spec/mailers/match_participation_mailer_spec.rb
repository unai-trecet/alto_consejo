# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchParticipationMailer, type: :mailer do
  describe 'match_participation_email' do
    let(:creator) { create(:user, :confirmed) }
    let(:player) { create(:user, :confirmed, username: 'testing-email') }
    let(:match) { create(:match, creator: creator) }

    subject { described_class.with(match: match, player: player, recipient: creator) }
    it 'creates an email with the correct content' do
      email = subject.match_participation_email
      ActionMailer::Base.deliveries.clear

      expect do
        email.deliver_now
      end.to change(ActionMailer::Base.deliveries, :count).from(0).to(1)

      delivery = ActionMailer::Base.deliveries.last

      expect(delivery.subject).to eq('testing-email se ha unido a la partida!')
      expect(delivery.to).to eq([creator.email])
      expect(email.from).to match_array('altoconsejo@gmail.com')

      html_body = email.html_part.body.to_s
      text_body = email.text_part.body.to_s
      expect(html_body).to include('testing-email')
      expect(text_body).to include('testing-email')

      match_url_email = match_url(match)
      player_url = user_url(player)

      expect(html_body).to have_link('testing-email', href: player_url)
      expect(html_body).to have_link('partida', href: match_url_email)

      expect(text_body).to have_link('testing-email', href: player_url)
      expect(text_body).to have_link('partida', href: match_url_email)
    end
  end
end
