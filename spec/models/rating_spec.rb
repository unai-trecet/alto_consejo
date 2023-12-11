require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:rateable) }

  it { should validate_presence_of(:value) }
  it { should validate_inclusion_of(:value).in_range(0..10) }

  describe 'uniqueness validation' do
    subject { Rating.new(user: create(:user), rateable: create(:game), value: 3) }
    it {
      should validate_uniqueness_of(:user_id).scoped_to(:rateable_type,
                                                        :rateable_id).with_message('can rate only once per item')
    }
  end
end
