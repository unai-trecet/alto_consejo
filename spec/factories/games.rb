FactoryBot.define do
  factory :game do
    name { 'MyString' }
    description { 'MyString' }
    author { '' }
    user { nil }
    bbg_link { 'MyText' }
    image { 'MyText' }
  end
end
