FactoryBot.define do
  factory :transaction do
    association :invoice
    sequence(:credit_card_number) { |n| (n + 4321000000000000).to_s}
    result { "success" }
    credit_card_expiration_date { "2019-10-03" }
  end
end
