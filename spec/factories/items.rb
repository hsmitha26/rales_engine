FactoryBot.define do
  factory :item do
    association :merchant
    sequence(:name) { |n| "Item  #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:unit_price) { |n| ("#{n}".to_i+1)*1.5 }
  end
end
