# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchInvitationMailer, type: :mailer do
  describe '.match_invitation_email' do
    it 'creates an email with the correct content' do
      user = create(:user, :confirmed, email: 'test@email.com')
      match = create(:match)
      email = MatchInvitationMailer.with(match:, recipient: user).match_invitation_email
      ActionMailer::Base.deliveries.clear

      expect do
        email.deliver_now
      end.to change(ActionMailer::Base.deliveries, :size).from(0).to(1)

      expect(email.to).to match_array(['test@email.com'])
      expect(email.subject).to eq('Has sido invitado/a a una partida!')
      expect(email.from).to match_array('altoconsejo@gmail.com')

      html_body = email.html_part.body.to_s
      text_body = email.text_part.body.to_s
      expect(html_body).to include(match.title)
      expect(text_body).to include(match.title)

      expect(html_body).to include(match.description.to_plain_text)
      expect(text_body).to include(match.description.to_plain_text)

      expect(html_body).to include(match.game.name)
      expect(text_body).to include(match.game.name)

      expect(html_body).to include(match.user.username)
      expect(text_body).to include(match.user.username)

      expect(html_body).to include(match.user.username)
      expect(text_body).to include(match.user.username)

      expect(html_body).to include(match.location)
      expect(text_body).to include(match.location)

      expect(html_body).to include(match.start_at.to_s)
      expect(text_body).to include(match.start_at.to_s)

      expect(html_body).to include(match.end_at.to_s)
      expect(text_body).to include(match.end_at.to_s)

      url = match_participants_url(match_id: match.id, user_id: user.id)
      body = Capybara::Node::Simple.new(html_body)
      form_action = body.find('form').native.attributes['action'].value
      expect(body).to have_button('aquí')
      expect(form_action).to eq(url)
      body = Capybara::Node::Simple.new(text_body)
      form_action = body.find('form').native.attributes['action'].value
      expect(body).to have_button('aquí')
      expect(form_action).to eq(url)
    end
  end
end
