require 'rails_helper'

RSpec.describe "Api::WarehousesControllers", type: :request do
  let(:plant_manager) do
    User.create!(
      email: "pm@test.com",
      password: "password123",
      full_name: "Plant Manager",
      role: :plant_manager
    )
  end

  let(:manager) do
    User.create!(
      email: "manager@test.com",
      password: "password123",
      full_name: "Manager",
      role: :manager
    )
  end

  let(:worker) do
    User.create!(
      email: "worker@test.com",
      password: "password123",
      full_name: "Worker",
      role: :warehouse_worker
    )
  end
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "GET /show" do
    it "returns a success response" do
      get "/api/warehouses/1"
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /create" do
    it "returns a success response" do
      post "/api/warehouses", params: { warehouse: { name: "Warehouse 1", location: "Location 1" } }
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT /update" do
    it "returns a success response" do
      put "/api/warehouses/1", params: { warehouse: { name: "Warehouse 1", location: "Location 1" } }
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /destroy" do
    it "returns a success response" do
      delete "/api/warehouses/1"
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /assign_manager" do
    it "returns a success response" do
      post "/api/warehouses/assign_manager/1", params: { manager_id: 1 }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /unassign_manager" do
    it "returns a success response" do
      post "/api/warehouses/unassign_manager/1", params: { manager_id: 1 }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /assign_worker" do
    it "returns a success response" do
      post "/api/warehouses/assign_worker/1", params: { worker_id: 1 }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /unassign_worker" do
    it "returns a success response" do
      post "/api/warehouses/unassign_worker/1", params: { worker_id: 1 }
      expect(response).to have_http_status(200)
    end
  end
end
