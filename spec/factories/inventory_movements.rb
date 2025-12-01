FactoryBot.define do
  factory :inventory_movement do
    association :product
    association :user
    quantity { 10 }
    movement_type { :entry }
    association :destination_warehouse, factory: :warehouse
    source_warehouse { nil }

    trait :entry do
      movement_type { :entry }
      association :destination_warehouse, factory: :warehouse
      source_warehouse { nil }
    end

    trait :exit do
      movement_type { :exit }
      association :source_warehouse, factory: :warehouse
      destination_warehouse { nil }
    end

    trait :transfer do
      movement_type { :transfer }
      association :source_warehouse, factory: :warehouse
      association :destination_warehouse, factory: :warehouse
    end
  end
end

