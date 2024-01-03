FactoryBot.define do
  factory :review do
    content { 'MyText' }
    user { association(:user) }
    game { association(:game) }
  end
end
