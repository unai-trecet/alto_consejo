FactoryBot.define do
  factory :review do
    content { "MyText" }
    user { nil }
    game { nil }
  end
end
