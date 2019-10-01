class Transaction < ApplicationRecord
  validates_presence_of :result, :credit_card_number
  belongs_to :invoice
end
