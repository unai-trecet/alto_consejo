# frozen_string_literal: true

FactoryBot.define do
  factory :match_participant do
    user { create(:user) }
    match { create(:match) }
  end
end
