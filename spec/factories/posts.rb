FactoryBot.define do
  factory :post do
    association :user

    title { Faker::Lorem.unique.sentence }
    body { Faker::Lorem.paragraph }
  end
end
