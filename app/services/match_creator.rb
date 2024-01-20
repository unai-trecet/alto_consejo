# app/services/match_creator.rb
class MatchCreator
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def call
    match = Match.new(@params.except(:creator_participates))
    handle_after_save(match) if match.save
    match
  end

  private

  def handle_after_save(match)
    if @params[:creator_participates]
      MatchParticipationManager.new(match_id: match.id, user_id: match.creator.id).call
    end
    MatchInvitationsManager.new(match:, sender: match.creator).call
  end
end
