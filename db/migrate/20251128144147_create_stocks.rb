class CreateStocks < ActiveRecord::Migration[8.1]
  def change
    create_table :stocks do |t|
      t.references :warehouse, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
