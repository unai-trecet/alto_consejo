# frozen_string_literal: true

FactoryBot.define do
  factory :match do
    title { Faker::Lorem.sentences(number: 1).first }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    user { create(:user, :confirmed) }
    game { create(:game) }
    location { Faker::Address.full_address }

    invited_users do
      usernames = []
      if User.count.positive?
        rand(8).times do |_x|
          username = User.order(Arel.sql('RANDOM()')).first.username
          usernames.push(username)
        end
      end
      usernames
    end

    number_of_players { invited_users.count + rand(2) }
    public { Faker::Boolean.boolean }
    start_at { Faker::Time.between(from: 1.month.ago, to: 1.month.since) }
    end_at { Faker::Time.between(from: start_at, to: start_at + 5.hours) }
  end
end
