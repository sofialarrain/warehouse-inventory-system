class InventoryMovement < ApplicationRecord
  belongs_to :product
  belongs_to :source_warehouse
  belongs_to :destination_warehouse
  belongs_to :user
end
