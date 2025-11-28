require 'rails_helper'

RSpec.describe "Api::InventoryMovementsControllers", type: :request do
  let(:plant_manager) do
    User.find_or_create_by!(
      email: "pm@test.com",
      password: "password123",
      full_name: "Plant Manager",
      role: :plant_manager
    )
  end

  let(:warehouse) do
    Warehouse.find_or_create_by!(
      name: "Test Warehouse",
      location: "Test Location"
    )
  end

  let(:product) do
    Product.find_or_create_by!(
      name: "Test Product",
      description: "Test Description",
      sku: "SKU001"
    )
  end

  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "POST /register_entry" do
    it "returns a success response" do
      post "/api/inventory/entry", params: { warehouse_id: 1, product_id: 1, quantity: 1 }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /register_exit" do
    it "returns a success response" do
  end

  describe "POST /register_transfer" do
    it "returns a success response" do
      post "/api/inventory/transfer", params: { source_warehouse_id: 1, destination_warehouse_id: 2, product_id: 1, quantity: 1 }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /movement_history" do
    it "returns a success response" do
      get "/api/inventory/history/1"
      expect(response).to have_http_status(200)
    end
  end
end
