FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    body  { Faker::Lorem.paragraph }
    association :user

    factory :admin_user_post do
      user { create(:admin_user) }
    end

    factory :regular_user_post do
      user { create(:regular_user) }
    end
  end
end
