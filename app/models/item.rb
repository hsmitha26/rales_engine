class Item < ApplicationRecord
  validates_presence_of :unit_price, :description, :name
  belongs_to :merchant
end
