FactoryBot.define do
  factory :game do
    name { Faker::Game.title }
    description { 'Amazing game.' }
    author { Faker::Book.author }
    user { create(:user) }
    bbg_link { "www.board_game_geek.com/#{Faker::Number.number(digits: 10)}" }
    image { Faker::Quotes::Chiquito.sentence }
  end
end
