FactoryBot.define do
  factory :warehouse do
    sequence(:name) { |n| "Warehouse #{n}" }
    sequence(:location) { |n| "Location #{n}, City" }
    manager { nil }

    trait :with_manager do
      association :manager, factory: :user, traits: [ :manager ]
    end
  end
end
