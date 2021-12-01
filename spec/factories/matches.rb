FactoryBot.define do
  factory :match do
    title { 'Game at my place' }
    description { 'An afternoon of good games and beers.' }
    user { user }
    game { game }
    location { 'my place' }
    number_of_players { 5 }
    start_at { '2021-11-24 18:09:43' }
    end_at { '2021-11-24 18:09:43' }
  end
end
