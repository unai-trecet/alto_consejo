# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'email validations' do
    it { should validate_presence_of(:email) }
    it { should allow_value('test1@test.com').for(:email) }
    it { should_not allow_value('foo').for(:email) }

    describe 'uniqueness' do
      subject { User.new(email: 'test1@test.com', password: '12345678', password_confirmation: '12345678') }
      it { should validate_uniqueness_of(:email) }
    end
  end

  describe 'password validations' do
    it { should have_secure_password }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(8) }
  end
end
