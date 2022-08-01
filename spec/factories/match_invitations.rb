# frozen_string_literal: true

FactoryBot.define do
  factory :match_invitation do
    user { create(:user) }
    match { create(:match) }
  end
end
