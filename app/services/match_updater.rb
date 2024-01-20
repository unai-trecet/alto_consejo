# app/services/match_updater.rb
class MatchUpdater
  def initialize(match, params)
    @match = match
    @params = params
  end

  def call
    handle_after_save if @match.update(@params.except(:creator_participates))
    @match
  end

  private

  def handle_after_save
    if @params[:creator_participates]
      MatchParticipationManager.new(match_id: @match.id, user_id: @match.creator.id).call
    end
    MatchInvitationsManager.new(match: @match, sender: @match.creator).call
  end
end
