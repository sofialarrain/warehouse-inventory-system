class Stock < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :warehouse_id, presence: true
  validates :product_id, presence: true
end
