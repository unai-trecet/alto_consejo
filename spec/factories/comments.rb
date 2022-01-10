# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user { nil }
    commentable { nil }
    parent_id { 1 }
    body { nil }
  end
end
