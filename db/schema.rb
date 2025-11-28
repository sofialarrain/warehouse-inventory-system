# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_28_144229) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "inventory_movements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "destination_warehouse_id", null: false
    t.integer "movement_type"
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.bigint "source_warehouse_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["destination_warehouse_id"], name: "index_inventory_movements_on_destination_warehouse_id"
    t.index ["product_id"], name: "index_inventory_movements_on_product_id"
    t.index ["source_warehouse_id"], name: "index_inventory_movements_on_source_warehouse_id"
    t.index ["user_id"], name: "index_inventory_movements_on_user_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "exp"
    t.string "jti"
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.string "sku"
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.datetime "updated_at", null: false
    t.bigint "warehouse_id", null: false
    t.index ["product_id"], name: "index_stocks_on_product_id"
    t.index ["warehouse_id"], name: "index_stocks_on_warehouse_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "warehouse_assignments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "warehouse_id", null: false
    t.index ["user_id"], name: "index_warehouse_assignments_on_user_id"
    t.index ["warehouse_id"], name: "index_warehouse_assignments_on_warehouse_id"
  end

  create_table "warehouses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "location"
    t.bigint "manager_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["manager_id"], name: "index_warehouses_on_manager_id"
  end

  add_foreign_key "inventory_movements", "products"
  add_foreign_key "inventory_movements", "users"
  add_foreign_key "inventory_movements", "warehouses", column: "destination_warehouse_id"
  add_foreign_key "inventory_movements", "warehouses", column: "source_warehouse_id"
  add_foreign_key "stocks", "products"
  add_foreign_key "stocks", "warehouses"
  add_foreign_key "warehouse_assignments", "users"
  add_foreign_key "warehouse_assignments", "warehouses"
  add_foreign_key "warehouses", "users", column: "manager_id"
end
