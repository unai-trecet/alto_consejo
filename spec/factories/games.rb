# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    name { Faker::Game.unique.title }
    description { Faker::Quotes::Chiquito.sentence }
    author { Faker::Book.author }
    user { create(:user, :confirmed) }
    bbg_link { "www.board_game_geek.com/#{Faker::Number.number(digits: 10)}" }
    image { 'an image' }
  end
end
