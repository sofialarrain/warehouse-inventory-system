FactoryBot.define do
  factory :product do
    name { "Product" }
    sequence(:sku) { |n| "SKU-#{n}" }
    description { "Description" }
  end
end
