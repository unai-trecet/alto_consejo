require 'rails_helper'

RSpec.describe FriendshipRequestMailer, type: :mailer do
  describe '#friendship_request_email' do
    let(:sender) { create(:user) }
    let(:recipient) { create(:user) }
    let(:friendship) { create(:friendship, user: sender, friend: recipient) }
    let(:mail) do
      FriendshipRequestMailer.with(recipient:, friendship:, sender:).friendship_request_email.deliver_now
    end

    it 'renders the headers correctly' do
      expect(mail.subject).to eq('Tienes una solicitud de amistad!')
      expect(mail.to).to eq([recipient.email])
      expect(mail.from).to eq(['altoconsejo@gmail.com'])
    end

    it 'renders the body correctly' do
      expect(mail.body.encoded).to include(sender.username)
      expect(mail.body.encoded).to match(url_for(sender))
      expect(mail.body.encoded).to match(friendship_url(friendship))
    end
  end
end
