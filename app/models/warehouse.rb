class Warehouse < ApplicationRecord
    belongs_to :manager, class_name: "User", optional: true
    has_many :warehouse_assignments
    has_many :workers, through: :warehouse_assignments, source: :user
    has_many :stocks
    has_many :products, through: :stocks

    validates :name, presence: true
end
