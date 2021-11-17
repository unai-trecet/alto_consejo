FactoryBot.define do
  factory :game do
    name { 'MyString' }
    description { 'MyString' }
    author { '' }
    user { create(:user) }
    bbg_link { 'MyText' }
    image { 'MyText' }
  end
end
