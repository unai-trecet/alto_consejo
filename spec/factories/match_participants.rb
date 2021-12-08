FactoryBot.define do
  factory :match_participant do
    user { create(:user) }
    match { create(:match) }
  end
end
