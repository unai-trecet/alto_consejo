# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordMailer, type: :mailer do
  describe 'reset' do
    let(:user) { create(:user) }
    let(:email) { described_class.with(user: user).reset }
    it 'renders the headers' do
      expect(email.subject).to eq('Reestablecer contraseña para el Alto Consejo.')
      expect(email.to.first).to eq(user.email)
    end
  end
end
