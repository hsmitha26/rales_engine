FactoryBot.define do
  factory :item do
    association :merchant
    sequence(:name) { |n| "Item  #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:unit_price) { |n| (n + 1) * 2 }
  end
end
