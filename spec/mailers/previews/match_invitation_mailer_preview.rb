# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/match_invitation
class MatchInvitationMailerPreview < ActionMailer::Preview
  def match_invitation_email
    user = FactoryBot.create(:user, :confirmed)
    match = FactoryBot.create(:match)
    MatchInvitationMailer.with(match:, recipient: user).match_invitation_email
  end
end
