FactoryBot.define do
  factory :post do
    association :user
    title { Faker::Lorem.unique.word }
    body  { Faker::Lorem.sentence(30) }
  end
end
