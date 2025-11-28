class CreateWarehouses < ActiveRecord::Migration[8.1]
  def change
    create_table :warehouses do |t|
      t.string :name
      t.string :location
      t.references :manager, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
