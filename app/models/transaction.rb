class Transaction < ApplicationRecord
  validates_presence_of :result, :credit_card_number
  belongs_to :invoice

  scope :successful, -> { where(result: "success") }
end
