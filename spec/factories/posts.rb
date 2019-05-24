FactoryBot.define do
  # Implementar factory
  factory :post do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    user
  end
end
