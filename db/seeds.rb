# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

plant_manager = User.find_or_initialize_by(email: "pm@test.com")
plant_manager.assign_attributes(
  password: "password123",
  full_name: "Plant Manager",
  role: :plant_manager
)
plant_manager.save!

manager1 = User.find_or_initialize_by(email: "manager1@test.com")
manager1.assign_attributes(
  password: "password123",
  full_name: "Manager 1",
  role: :manager
)
manager1.save!

manager2 = User.find_or_initialize_by(email: "manager2@test.com")
manager2.assign_attributes(
  password: "password123",
  full_name: "Manager 2",
  role: :manager
)
manager2.save!

worker1 = User.find_or_initialize_by(email: "worker1@test.com")
worker1.assign_attributes(
  password: "password123",
  full_name: "Worker",
  role: :warehouse_worker
)
worker1.save!

worker2 = User.find_or_initialize_by(email: "worker2@test.com")
worker2.assign_attributes(
  password: "password123",
  full_name: "Worker 2",
  role: :warehouse_worker
)
worker2.save!

worker3 = User.find_or_initialize_by(email: "worker3@test.com")
worker3.assign_attributes(
  password: "password123",
  full_name: "Worker 3",
  role: :warehouse_worker
)
worker3.save!

warehouse1 = Warehouse.find_or_create_by!(
  name: "Warehouse 1",
  location: "Location 1",
  manager_id: manager2.id
)

warehouse2 = Warehouse.find_or_create_by!(
  name: "Warehouse 2",
  location: "Location 2",
  manager_id: manager2.id
)

warehouse3 = Warehouse.find_or_create_by!(
  name: "Warehouse 3",
  location: "Location 3",
  manager_id: manager1.id
)

product1 = Product.find_or_create_by!(
  name: "Product 1",
  description: "Description 1",
  sku: "SKU1"
)

product2 = Product.find_or_create_by!(
  name: "Product 2",
  description: "Description 2",
  sku: "SKU2"
)

product3 = Product.find_or_create_by!(
  name: "Product 3",
  description: "Description 3",
  sku: "SKU3"
)

product4 = Product.find_or_create_by!(
  name: "Product 4",
  description: "Description 4",
  sku: "SKU4"
)

product5 = Product.find_or_create_by!(
  name: "Product 5",
  description: "Description 5",
  sku: "SKU5"
)

product6 = Product.find_or_create_by!(
  name: "Product 6",
  description: "Description 6",
  sku: "SKU6"
)

product7 = Product.find_or_create_by!(
  name: "Product 7",
  description: "Description 7",
  sku: "SKU7"
)

product8 = Product.find_or_create_by!(
  name: "Product 8",
  description: "Description 8",
  sku: "SKU8"
)

product9 = Product.find_or_create_by!(
  name: "Product 9",
  description: "Description 9",
  sku: "SKU9"
)

product10 = Product.find_or_create_by!(
  name: "Product 10",
  description: "Description 10",
  sku: "SKU10"
)

# Assign workers to warehouses
WarehouseAssignment.find_or_create_by!(user: worker1, warehouse: warehouse1)
WarehouseAssignment.find_or_create_by!(user: worker1, warehouse: warehouse2)
WarehouseAssignment.find_or_create_by!(user: worker1, warehouse: warehouse3)

WarehouseAssignment.find_or_create_by!(user: worker2, warehouse: warehouse1)
WarehouseAssignment.find_or_create_by!(user: worker2, warehouse: warehouse2)

WarehouseAssignment.find_or_create_by!(user: worker3, warehouse: warehouse2)
WarehouseAssignment.find_or_create_by!(user: worker3, warehouse: warehouse3)

# Assign products to warehouses
Stock.find_or_create_by!(product: product1, warehouse: warehouse1, quantity: 100)
Stock.find_or_create_by!(product: product1, warehouse: warehouse3, quantity: 200)

Stock.find_or_create_by!(product: product2, warehouse: warehouse1, quantity: 50)
Stock.find_or_create_by!(product: product2, warehouse: warehouse2, quantity: 500)
Stock.find_or_create_by!(product: product2, warehouse: warehouse3, quantity: 300)

Stock.find_or_create_by!(product: product3, warehouse: warehouse2, quantity: 100)
Stock.find_or_create_by!(product: product3, warehouse: warehouse3, quantity: 200)

Stock.find_or_create_by!(product: product4, warehouse: warehouse1, quantity: 1000)
Stock.find_or_create_by!(product: product4, warehouse: warehouse2, quantity: 900)

Stock.find_or_create_by!(product: product5, warehouse: warehouse1, quantity: 30)
Stock.find_or_create_by!(product: product5, warehouse: warehouse2, quantity: 400)
Stock.find_or_create_by!(product: product5, warehouse: warehouse3, quantity: 100)

Stock.find_or_create_by!(product: product6, warehouse: warehouse1, quantity: 100)
Stock.find_or_create_by!(product: product6, warehouse: warehouse2, quantity: 600)
Stock.find_or_create_by!(product: product6, warehouse: warehouse3, quantity: 700)

Stock.find_or_create_by!(product: product7, warehouse: warehouse1, quantity: 2000)
Stock.find_or_create_by!(product: product7, warehouse: warehouse3, quantity: 100)

Stock.find_or_create_by!(product: product8, warehouse: warehouse2, quantity: 60)
Stock.find_or_create_by!(product: product8, warehouse: warehouse3, quantity: 400)

Stock.find_or_create_by!(product: product9, warehouse: warehouse1, quantity: 100)
Stock.find_or_create_by!(product: product9, warehouse: warehouse2, quantity: 200)

Stock.find_or_create_by!(product: product10, warehouse: warehouse1, quantity: 600)
Stock.find_or_create_by!(product: product10, warehouse: warehouse3, quantity: 300)

# Assign inventory movements
InventoryMovement.find_or_create_by!(product: product1, quantity: 20, movement_type: :entry, destination_warehouse_id: warehouse1.id, user: worker1)
InventoryMovement.find_or_create_by!(product: product3, quantity: 100, movement_type: :entry, destination_warehouse_id: warehouse2.id, user: worker2)
InventoryMovement.find_or_create_by!(product: product4, quantity: 1000, movement_type: :entry, destination_warehouse_id: warehouse1.id, user: worker1)
InventoryMovement.find_or_create_by!(product: product5, quantity: 30, movement_type: :entry, destination_warehouse_id: warehouse1.id, user: worker1)
InventoryMovement.find_or_create_by!(product: product8, quantity: 60, movement_type: :entry, destination_warehouse_id: warehouse2.id, user: worker2)
InventoryMovement.find_or_create_by!(product: product9, quantity: 100, movement_type: :entry, destination_warehouse_id: warehouse1.id, user: worker1)
InventoryMovement.find_or_create_by!(product: product10, quantity: 600, movement_type: :entry, destination_warehouse_id: warehouse1.id, user: worker1)

InventoryMovement.find_or_create_by!(product: product4, quantity: 900, movement_type: :exit, source_warehouse_id: warehouse2.id, user: worker2)
InventoryMovement.find_or_create_by!(product: product5, quantity: 400, movement_type: :exit, source_warehouse_id: warehouse2.id, user: worker2)
InventoryMovement.find_or_create_by!(product: product6, quantity: 700, movement_type: :exit, source_warehouse_id: warehouse3.id, user: worker3)
InventoryMovement.find_or_create_by!(product: product7, quantity: 100, movement_type: :exit, source_warehouse_id: warehouse3.id, user: worker3)
InventoryMovement.find_or_create_by!(product: product8, quantity: 400, movement_type: :exit, source_warehouse_id: warehouse3.id, user: worker3)

InventoryMovement.find_or_create_by!(product: product1, quantity: 200, movement_type: :transfer, source_warehouse_id: warehouse1.id, destination_warehouse_id: warehouse3.id, user: worker3)
InventoryMovement.find_or_create_by!(product: product2, quantity: 50, movement_type: :transfer, source_warehouse_id: warehouse2.id, destination_warehouse_id: warehouse1.id, user: worker1)
InventoryMovement.find_or_create_by!(product: product5, quantity: 30, movement_type: :transfer, source_warehouse_id: warehouse2.id, destination_warehouse_id: warehouse1.id, user: worker1)
InventoryMovement.find_or_create_by!(product: product6, quantity: 100, movement_type: :transfer, source_warehouse_id: warehouse3.id, destination_warehouse_id: warehouse1.id, user: worker1)
InventoryMovement.find_or_create_by!(product: product7, quantity: 2000, movement_type: :transfer, source_warehouse_id: warehouse3.id, destination_warehouse_id: warehouse1.id, user: worker1)
