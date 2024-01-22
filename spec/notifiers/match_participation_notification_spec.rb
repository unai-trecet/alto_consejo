require 'rails_helper'

RSpec.describe MatchParticipationNotification do
  describe '.deliver' do
    let(:creator) { create(:user, :confirmed) }
    let(:player) { create(:user, :confirmed) }
    let(:match) { create(:match, user: creator, game: create(:game, user: creator)) }
    let!(:recipients) { create_list(:user, 2) }

    subject { described_class.with(match:, player:, sender: player) }

    it 'sends proper email to recipients and create Notifications' do
      subject
      ActionMailer::Base.deliveries.clear

      expect(MatchParticipationMailer)
        .to receive(:with)
        .twice
        .and_call_original
      allow_any_instance_of(MatchParticipationMailer)
        .to receive(:match_participation_email)
        .and_call_original

      perform_enqueued_jobs do
        expect do
          subject.deliver(recipients)
        end.to change { ActionMailer::Base.deliveries.count }
          .from(0).to(2)
          .and change(Noticed::Notification, :count)
          .from(0).to(2)
      end

      expect(ActionMailer::Base.deliveries.map { |el| el.to.join })
        .to match_array(recipients.pluck(:email))

      expect(Noticed::Notification.pluck(:recipient_id)).to match_array(recipients.pluck(:id))

      Noticed::Notification.all.each do |notification|
        expect(notification.params[:match]).to eq(match)
        expect(notification.params[:sender]).to eq(player)
        expect(notification.params[:player]).to eq(player)
      end
    end
  end
end
