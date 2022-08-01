# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { create(:comment) }

  it { should belong_to(:user) }
  it { should belong_to(:commentable) }
  it { should belong_to(:parent).optional }

  it { should have_many(:comments) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user) }
end
