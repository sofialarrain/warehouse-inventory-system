class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum :role, { warehouse_worker: 0, manager: 1, plant_manager: 2 }

  has_many :managed_warehouses, class_name: "Warehouse", foreign_key: "manager_id"
  has_many :warehouse_assignments
  has_many :assigned_warehouses, through: :warehouse_assignments, source: :warehouse
  has_many :inventory_movements

  validates :full_name, presence: true
  validates :role, presence: true

  def on_jwt_dispatch(payload, token)
    payload[:role] = role
    payload[:full_name] = full_name
  end
end
