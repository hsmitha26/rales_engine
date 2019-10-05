FactoryBot.define do
  factory :invoice_item do
    item
    invoice
    sequence(:quantity) { |n| (n + 1) }
    sequence(:unit_price) { |n| (n + 1) }
  end
end
