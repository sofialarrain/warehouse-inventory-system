class CreateInventoryMovements < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_movements do |t|
      t.references :product, null: false, foreign_key: true
      t.references :source_warehouse, null: true, foreign_key: { to_table: :warehouses }
      t.references :destination_warehouse, null: true, foreign_key: { to_table: :warehouses }
      t.references :user, null: false, foreign_key: true
      t.integer :quantity
      t.integer :movement_type

      t.timestamps
    end
  end
end
