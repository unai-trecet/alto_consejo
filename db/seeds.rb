# frozen_string_literal: true

require 'database_cleaner/active_record'
require 'factory_bot_rails'

DatabaseCleaner.clean_with(:truncation)

def pick_random_object(model)
  model.order(Arel.sql('RANDOM()')).first
end

puts 'Users creation!'

100.times do |_i|
  user = FactoryBot.create(:user, :confirmed)
  print '.'
end

puts ''
puts 'Games creation!'

100.times do |_i|
  game = FactoryBot.create(:game, user: pick_random_object(User))
  print '.'
end

puts ''
puts 'Matches creation!'

500.times do |_i|
  FactoryBot.create(:match, user: pick_random_object(User),
                            game: pick_random_object(Game))
  print '.'
end

puts ''
puts 'MatchInvitations creation!'

Match.all.each do |match|
  MatchInvitationsManager.new(match: match).call
  MatchParticipationManager.new(match_id: match.id, user_id: match.creator.id).call unless (match.id % 5).zero?
  print '.'
end

puts ''
puts 'MatchParticitations creation!'

300.times do |_x|
  match = Match.find_by(id: rand(500))
  MatchParticipationManager.new(match_id: match.id, user_id: match.creator.id).call if match
  print '.'
end

puts 'Seeding end!'
