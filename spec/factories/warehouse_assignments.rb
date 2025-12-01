FactoryBot.define do
  factory :warehouse_assignment do
    association :user
    association :warehouse
  end
end

