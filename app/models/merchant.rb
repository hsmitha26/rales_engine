class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices

  def self.random
    random_id = pluck(:id).sample
    self.where(id: random_id).first
  end
end
