FactoryBot.define do
  factory :game do
    name { Faker::Game.title + Faker::Number.number(digits: 10).to_s }
    description { Faker::Quotes::Chiquito.sentence }
    author { Faker::Book.author }
    user { create(:user, :confirmed) }
    bbg_link { "www.board_game_geek.com/#{Faker::Number.number(digits: 10)}" }
  end
end