FactoryBot.define do
  factory :rating do
    user { nil }
    rateable { nil }
    value { 1 }
  end
end
