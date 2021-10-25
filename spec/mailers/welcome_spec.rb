require 'rails_helper'

RSpec.describe WelcomeMailer, type: :mailer do
  describe 'welcome_email' do
    let(:invited_user) { create(:user) }
    let(:email) { described_class.with(user: invited_user).welcome_email }
    it 'renders the headers' do
      expect(email.subject).to eq('Bienvenido, ocupe su sitio en el Alto Consejo Friki')
      expect(email.to.first).to eq(invited_user.email)
    end
  end
end
