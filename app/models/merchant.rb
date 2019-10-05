class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices

  def self.random
    random_id = pluck(:id).sample
    self.where(id: random_id).first
  end

  def self.top_merchant_by_revenue(number_of_merchants)
    self.joins(invoices: [:invoice_items])
    .joins(invoices: [:transactions])
    .group(:id)
    .merge(Transaction.successful)
    .select("merchants.*, SUM(quantity * unit_price) AS revenue")
    .order("revenue DESC")
    .limit(number_of_merchants)
  end
end
