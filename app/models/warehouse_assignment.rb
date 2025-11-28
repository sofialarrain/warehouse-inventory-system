class WarehouseAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :warehouse

  validates :user_id, uniqueness: { scope: :warehouse_id }
end