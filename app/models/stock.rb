class Stock < ApplicationRecord
    belongs_to :warehouse
    belongs_to :product

    validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :warehouse_id, presence: true, uniqueness: { scope: :product_id, message: "stock already exists for this product in this warehouse" }
    validates :product_id, presence: true
end
