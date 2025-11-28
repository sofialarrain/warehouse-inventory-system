class Product < ApplicationRecord
    has_many :stocks
    has_many :warehouses, through: :stocks
    has_many :inventory_movements

    validates :name, presence: true
    validates :sku, presence: true, uniqueness: true
end
