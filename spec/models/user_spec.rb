# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }

  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of(:username) }

  it { should have_many(:notifications) }
  it { should have_many(:games) }
  it { should have_many(:matches) }
  it { should have_many(:match_participants) }
  it {
    should have_many(:participations)
      .through(:match_participants)
      .source(:match)
  }
  it { should have_many(:match_invitations) }
  it {
    should have_many(:invitations)
      .through(:match_invitations)
      .source(:match)
  }
  it {
    should have_many(:played_matches)
      .through(:match_participants)
      .source(:match)
  }
  it {
    should have_many(:not_played_matches)
      .through(:match_participants)
      .source(:match)
  }
  it {
    should have_many(:played_games)
      .through(:played_matches)
      .source(:game)
  }

  it { should have_one_attached(:avatar) }

  describe 'scopes' do
    describe '#played_matches' do
      subject { create(:user, :confirmed) }

      it 'returns only passed matches' do
        played_match = create(:match, end_at: 1.hour.ago)
        future_match = create(:match, end_at: 1.hour.since)
        create(:match_participant, user: subject, match: played_match)
        create(:match_participant, user: subject, match: future_match)

        expect(subject.played_matches).to match_array([played_match])
      end
    end
  end

  describe '#avatar_as_thumbnail' do
    subject { create(:user, :confirmed) }

    it 'returns resized processed files' do
      subject.avatar.attach(
        io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.png')),
        filename: 'default_avatar.png',
        content_type: 'image/png'
      )

      expect(subject.avatar_as_thumbnail.blob.filename).to eq('default_avatar.png')
      expect(subject.avatar_as_thumbnail.variation.transformations).to eq({ format: 'png',
                                                                            resize_to_limit: [150, 150] })
    end
  end

  describe '#add_default_avatar' do
    subject { create(:user, :confirmed) }

    it 'attaches the default avatar to the user' do
      expect(subject.avatar.blob.filename).to eq('default_avatar.png')
    end
  end
end
