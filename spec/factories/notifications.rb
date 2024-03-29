FactoryBot.define do
  factory :notification do
    recipient { create(:user) }
    type { 'MatchInvitationNotification' }
    params { { sender: create(:user) } }
    read_at { '2021-12-01 17:47:54' }

    trait :match_invitation_notification do
      params { { match: create(:match) } }
    end
  end
end
