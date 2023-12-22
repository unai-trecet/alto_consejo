# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Match, type: :model do
  # Associations
  it { should belong_to(:user) }
  it { should belong_to(:game) }

  it { should have_many(:match_participants) }
  it {
    should have_many(:participants)
      .through(:match_participants)
      .source(:user)
  }

  it { should have_many(:match_invitations) }
  it {
    should have_many(:invitees)
      .through(:match_invitations)
      .source(:user)
  }

  it { should have_many(:comments) }

  it { should have_many_attached(:pictures) }
  it { should have_one_attached(:image) }
  it { should have_rich_text(:description) }

  # Validations
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:end_at) }

  describe 'scopes' do
    describe 'public' do
      it 'returns only passed matches' do
        public_match1 = create(:match, public: true)
        public_match2 = create(:match, public: true)
        create(:match, public: false)

        expect(Match.open).to match_array([public_match1, public_match2])
      end
    end

    describe '.closed' do
      let!(:public_game) { create(:game, public: true) }
      let!(:private_game) { create(:game, public: false) }

      it 'returns only private games' do
        expect(Game.closed).to match_array([private_game])
      end
    end

    describe 'played' do
      it 'returns only passed matches' do
        played_match1 = create(:match, end_at: DateTime.now - 1.day)
        played_match2 = create(:match, end_at: DateTime.now - 2.day)
        create(:match, end_at: DateTime.now + 1.minute)
        create(:match, end_at: DateTime.now + 1.day)

        expect(Match.played).to match_array([played_match1, played_match2])
      end
    end

    describe 'not_played' do
      it 'returns only passed matches' do
        create(:match, end_at: DateTime.now - 1.day)
        create(:match, end_at: DateTime.now - 2.day)
        not_played_match1 = create(:match, end_at: DateTime.now + 1.minute)
        not_played_match2 = create(:match, end_at: DateTime.now + 1.day)

        expect(Match.not_played).to match_array([not_played_match1, not_played_match2])
      end
    end

    context 'filters _by_user' do
      let(:user) { create(:user, :confirmed) }
      let(:another_user) { create(:user, :confirmed) }

      let!(:not_public_match) { create(:match, title: 'Not public Match', user: another_user, public: false) }
      let!(:public_match) { create(:match, title: 'Public Match', public: true, user: another_user) }
      let!(:invitation_match) { create(:match, title: 'Invitation Match', user: another_user, public: false) }
      let!(:participated_match_past) do
        create(:match, title: 'Participation Match Played', user: another_user, public: false, end_at: 1.hour.ago)
      end
      let!(:participated_match_future) do
        create(:match, title: 'Participation Match Future', user: another_user, public: false, end_at: 1.hour.since)
      end
      let!(:created_match) { create(:match, title: 'Created Match', user:, public: false, end_at: 1.hour.since) }

      before do
        create(:match_invitation, match: invitation_match, user:)
        create(:match_participant, match: created_match, user:)
        create(:match_participant, match: participated_match_past, user:)
        create(:match_participant, match: participated_match_future, user:)

        create(:match_invitation, match: invitation_match, user: another_user)
        create(:match_participant, match: participated_match_past, user: another_user)
        create(:match_participant, match: participated_match_future, user: another_user)

        create(:match_invitation, match: created_match)
        create(:match_invitation, match: created_match)

        create(:match_participant, match: created_match)
        create(:match_participant, match: created_match)
      end

      describe 'all_by_user' do
        it 'returns public matches or user has participation, invitation or created Match' do
          result = Match.all_by_user(user.id)

          expect(Match.count).to eq(6)
          expect(result.size).to eq(5)
          expect(result.pluck(:title))
            .to match_array(['Public Match', 'Invitation Match', 'Participation Match Future', 'Created Match',
                             'Participation Match Played'])
          expect(result.pluck(:id))
            .to match_array([public_match.id, invitation_match.id, participated_match_past.id,
                             participated_match_future.id, created_match.id])
        end
      end

      describe 'participations_by_user' do
        it 'returns matches participated to which the user was invited' do
          result = Match.participations_by_user(user.id)

          expect(Match.count).to eq(6)
          expect(result.size).to eq(3)
          expect(result.pluck(:title)).to match_array(['Participation Match Future', 'Created Match',
                                                       'Participation Match Played'])
          expect(result.pluck(:id)).to match_array([created_match.id, participated_match_past.id,
                                                    participated_match_future.id])
        end
      end

      describe 'played_by_user' do
        it 'returns matches participated by user already played' do
          result = Match.played_by_user(user.id)

          expect(Match.count).to eq(6)
          expect(result.size).to eq(1)
          expect(result.pluck(:title)).to match_array(['Participation Match Played'])
          expect(result.pluck(:id)).to match_array([participated_match_past.id])
        end
      end

      describe 'not_played_by_user' do
        it 'returns matches participated by user not yet played' do
          result = Match.not_played_by_user(user.id)

          expect(Match.count).to eq(6)
          expect(result.size).to eq(2)
          expect(result.pluck(:title)).to match_array(['Participation Match Future', 'Created Match'])
          expect(result.pluck(:id)).to match_array([participated_match_future.id, created_match.id])
        end
      end

      describe 'invitations_by_user' do
        it 'returns matches participated to which the user was invited' do
          result = Match.invitations_by_user(user.id)

          expect(Match.count).to eq(6)
          expect(result.size).to eq(1)
          expect(result.pluck(:title)).to match_array(['Invitation Match'])
        end
      end

      describe 'created_by_user' do
        it 'returns matches participated to which the user was invited' do
          result = Match.created_by_user(user.id)

          expect(Match.count).to eq(6)
          expect(result.size).to eq(1)
          expect(result.pluck(:title)).to match_array(['Created Match'])
        end
      end

      describe 'related_to_user' do
        it 'returns matches created, participated by the user or where was invited' do
          result = Match.related_to_user(user.id)

          expect(Match.count).to eq(6)
          expect(result.size).to eq(4)
          expect(result.pluck(:title)).to match_array(['Participation Match Future', 'Created Match',
                                                       'Participation Match Played', 'Invitation Match'])
          expect(result.pluck(:id)).to match_array([created_match.id, participated_match_past.id,
                                                    participated_match_future.id, invitation_match.id])
        end
      end
    end
  end

  describe '#creator_name' do
    it 'returns match creator username' do
      alicia = create(:user, :confirmed, username: 'alicia')
      match = create(:match, user: alicia)

      expect(match.creator_name).to eq('alicia')
    end
  end

  describe '#game_name' do
    it 'returns match creator username' do
      terraforming = create(:game, name: 'Terraforming Mars')
      match = create(:match, game: terraforming)

      expect(match.game_name).to eq('Terraforming Mars')
    end
  end
end
