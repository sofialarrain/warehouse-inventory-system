class InventoryMovement < ApplicationRecord
    belongs_to :product
    belongs_to :source_warehouse, class_name: "Warehouse", optional: true
    belongs_to :destination_warehouse, class_name: "Warehouse", optional: true
    belongs_to :user

    enum :movement_type, { entry: 0, exit: 1, transfer: 2 }

    validates :quantity, numericality: { greater_than: 0 }
    validates :movement_type, presence: true
    validates :product_id, presence: true
    validates :user_id, presence: true
    validates :source_warehouse_id, presence: true, if: -> { exit? || transfer? }
    validates :destination_warehouse_id, presence: true, if: -> { entry? || transfer? }
end
