# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }

    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:username) }

    it { should validate_inclusion_of(:role).in_array(%w[user admin]) }
  end

  describe 'associations' do
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

    it { should have_many(:authored_comments).class_name('Comment') }
    it { should have_many(:comments).class_name('Comment') }
    it { should have_many(:ratings) }
    it { should have_many(:reviews) }

    # Friendships
    it {
      should have_many(:friendships)
        .conditions("user_id = #{subject.id} OR friend_id = #{subject.id}")
    }
    it {
      should have_many(:accepted_friendships)
        .class_name('Friendship')
        .conditions("friendships.accepted_at IS NOT NULL AND user_id = #{subject.id} OR friend_id = #{subject.id}")
    }

    it {
      should have_many(:pending_friendships)
        .class_name('Friendship')
        .conditions("friendships.accepted_at IS  NULL AND user_id = #{subject.id} OR friend_id = #{subject.id}")
    }
  end

  describe '#friends' do
    let(:user) { create(:user, :confirmed) }
    let(:friend1) { create(:user, :confirmed) }
    let(:friend2) { create(:user, :confirmed) }
    let(:friend3) { create(:user, :confirmed) }

    let!(:friendship1) { create(:friendship, user:, friend: friend1, accepted_at: Time.now) }
    let!(:friendship2) { create(:friendship, user:, friend: friend2, accepted_at: Time.now) }
    let!(:friendship3) { create(:friendship, user:, friend: friend3, accepted_at: nil) }

    it 'returns all the user\'s friends that has accepted' do
      expect(user.friends).to match_array([friend1, friend2])
    end

    it 'returns friends where the user is the friend (it works reversely)' do
      expect(friend1.friends).to match_array([user])
      expect(friend2.friends).to match_array([user])
    end

    it 'returns no user\'s friendships when they are not yet accepted' do
      expect(friend3.friends).to be_empty
    end
  end

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

  describe '#add_default_avatar' do
    it 'sets default avatar after creation when is not provided' do
      user = build(:user)

      expect(user.avatar.attached?).to be_falsey

      user.save

      expect(user.avatar.attached?).to eq(true)
      expect(user.avatar.filename).to eq('default_avatar.png')
    end

    it 'sets default avatar after update when is not provided' do
      user = build(:user)

      expect(user.avatar.attached?).to be_falsey

      user.update(username: 'new_username')

      expect(user.avatar.attached?).to eq(true)
      expect(user.avatar.filename).to eq('default_avatar.png')
    end

    it 'does not set default when it is already set' do
      user = create(:user)
      user.avatar.attach(
        io: File.open(Rails.root.join('app', 'assets', 'images', 'avatar2.jpg')),
        filename: 'avatar2.jpg',
        content_type: 'image/png'
      )

      user.update(username: 'new_username')

      expect(user.avatar.attached?).to eq(true)
      expect(user.avatar.filename).to eq('avatar2.jpg')
    end
  end
end
