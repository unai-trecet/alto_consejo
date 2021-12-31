# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }

  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of(:username) }

  it { should have_many(:notifications) }
  it { should have_many(:games) }
  it { should have_many(:matches) }
  it { should have_many(:match_participants) }
  it {
    should have_many(:participations)
      .through(:match_participants)
      .source(:match)
  }
  it { should have_many(:match_invitations) }
  it {
    should have_many(:invitations)
      .through(:match_invitations)
      .source(:match)
  }
end
