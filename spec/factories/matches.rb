FactoryBot.define do
  factory :match do
    title { "MyText" }
    description { "MyText" }
    user { nil }
    game { nil }
    location { "MyText" }
    number_of_players { 1 }
    start_at { "2021-11-24 18:09:43" }
    end_at { "2021-11-24 18:09:43" }
  end
end
