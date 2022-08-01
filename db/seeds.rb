# frozen_string_literal: true

require 'database_cleaner/active_record'
require 'factory_bot_rails'

puts 'POPULATING DB!'

DatabaseCleaner.clean_with(:truncation)
puts 'DB clean up done.'

def pick_random_object(model)
  model.find(rand(1..model.count))
end

puts 'Users creation!'

100.times do |_i|
  FactoryBot.create(:user, :confirmed)
  print '.'
end

puts ''
puts 'Games creation!'

100.times do |_i|
  FactoryBot.create(:game, user: pick_random_object(User))
  print '.'
end

puts ''
puts 'Matches creation!'

500.times do |_i|
  creator = pick_random_object(User)
  # TODO: seguro que esto se ppuede mejorar.
  invited_users = (0..rand(8)).to_a.map { |_el| pick_random_object(User).username } - [creator.username]
  match = FactoryBot.create(:match, user: creator,
                                    game: pick_random_object(Game),
                                    number_of_players: invited_users.count + rand(1),
                                    invited_users: invited_users)
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
  match = Match.find_by(id: rand(1..500))
  invitee = match.invitees.sample
  MatchParticipationManager.new(match_id: match.id, user_id: invitee.id).call if invitee
  print '.'
end

puts 'Seeding End!!!!'
