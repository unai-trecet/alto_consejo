# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  subject { create(:notification) }

  it { should belong_to(:recipient) }

  describe 'validations' do
    xit 'validates presence of sender in params' do
      params = { match: create(:match) }
      notification = build(:notification, params:)

      expect(notification.valid?).to be_falsey
      expect(notification.errors.full_messages).to eq(['Params[:sender] El usuario iniciador de la notificación debe estar presente.'])
    end
  end
end
