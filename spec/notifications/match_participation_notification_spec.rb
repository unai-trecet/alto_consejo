# frozen_string_literal: true

RSpec.describe MatchParticipationNotification do
  describe '.deliver' do
    let(:creator) { create(:user, :confirmed) }
    let(:player) { create(:user, :confirmed) }
    let(:match) { create(:match, user: creator, game: create(:game, user: creator)) }
    let!(:recipients) { create_list(:user, 2) }

    subject { described_class.with(match: match, player: player) }

    it 'sends proper email to recipients and create Notifications' do
      subject
      ActionMailer::Base.deliveries.clear

      expect(MatchParticipationMailer)
        .to receive(:with)
        .twice
        .and_call_original

      expect do
        subject.deliver(recipients)
      end.to change(ActionMailer::Base.deliveries, :size)
        .from(0).to(2)
        .and change(Notification, :count)
        .from(0).to(2)

      expect(ActionMailer::Base.deliveries.map { |el| el.to.join })
        .to match_array(recipients.pluck(:email))

      expect(Notification.pluck(:recipient_id)).to match_array(recipients.pluck(:id))

      expect(Notification.first.params[:match]).to eq(match)
      expect(Notification.last.params[:match]).to eq(match)

      expect(Notification.first.params[:player]).to eq(player)
      expect(Notification.last.params[:player]).to eq(player)
    end
  end
end
