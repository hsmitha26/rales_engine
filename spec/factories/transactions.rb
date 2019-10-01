FactoryBot.define do
  factory :transaction do
    credit_card_number { 1 }
    result { "MyString" }
    credit_card_expiration_date { "MyString" }
    invoice { nil }
  end
end
