FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    sequence(:full_name) { |n| "User #{n}" }
    role { :warehouse_worker }

    trait :manager do
      role { :manager }
    end

    trait :plant_manager do
      role { :plant_manager }
    end

    trait :warehouse_worker do
      role { :warehouse_worker }
    end
  end
end
