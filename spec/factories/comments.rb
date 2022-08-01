# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user { create(:user, :confirmed) }
    # We need a commentable object to create the first comment.
    commentable { create(:match) }
    parent_id { nil }
    body { Faker::Lorem.paragraph(sentence_count: 2) }
  end
end
