FactoryBot.define do
  factory :post do
    title { Faker::App.name }
    body  { Faker::Lorem.paragraph }
    association :user
  end
end
