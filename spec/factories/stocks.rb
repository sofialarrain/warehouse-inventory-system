FactoryBot.define do
  factory :stock do
    association :warehouse
    association :product
    quantity { 100 }
  end
end

