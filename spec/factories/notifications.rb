# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    recipient { create(:user) }
    type { 'MatchInvitationNotification' }
    params {}
    read_at { '2021-12-01 17:47:54' }

    trait :match_invitation_notification do
      params { { match: create(:match) } }
    end
  end
end
