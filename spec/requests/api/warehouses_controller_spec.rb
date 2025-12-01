require 'rails_helper'

RSpec.describe "Api::WarehousesControllers", type: :request do
  describe "GET /index" do
    let(:user) { create(:user, :plant_manager) }

    before do
      create_list(:warehouse, 3)
    end

    it "returns a success response" do
      get "/api/warehouses", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq("Success")
      expect(json_response['data']).to be_present
      expect(json_response['data'].length).to eq(3)
    end

    it "returns paginated results" do
      get "/api/warehouses", params: { page: 1, per: 2 }, headers: auth_headers(user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response['data']).to be_present
      expect(json_response['data'].length).to eq(2)
    end
  end

  describe "GET /show" do
    let(:user) { create(:user, :plant_manager) }
    let(:warehouse) { create(:warehouse) }

    it "returns a success response" do
      get "/api/warehouses/#{warehouse.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(warehouse.name)
    end

    it "returns a not found response" do
      get "/api/warehouses/999999", headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /create" do
    let(:user) { create(:user, :plant_manager) }

    it "returns a success response" do
      post "/api/warehouses", params: { warehouse: { name: "Warehouse 1", location: "Location 1" } }, headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Warehouse 1")
    end

    it "returns a unprocessable entity response" do
      post "/api/warehouses", params: { warehouse: { name: "", location: "Location 1" } }, headers: auth_headers(user)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Name can't be blank")
    end
  end

  describe "PUT /update" do
    let(:user) { create(:user, :plant_manager) }
    let(:warehouse) { create(:warehouse) }

    it "returns a success response" do
      put "/api/warehouses/#{warehouse.id}", params: { warehouse: { name: "Warehouse 1", location: "Location 1" } }, headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Warehouse 1")
    end

    it "returns a unprocessable entity response" do
      put "/api/warehouses/#{warehouse.id}", params: { warehouse: { name: "", location: "Location 1" } }, headers: auth_headers(user)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Name can't be blank")
    end
  end

  describe "DELETE /destroy" do
    let(:user) { create(:user, :plant_manager) }
    let(:warehouse) { create(:warehouse) }

    it "returns a success response" do
      delete "/api/warehouses/#{warehouse.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Warehouse deleted successfully")
    end

    it "returns a not found response" do
      delete "/api/warehouses/999999", headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /assign_manager" do
    let(:user) { create(:user, :plant_manager) }
    let(:warehouse) { create(:warehouse) }
    let(:manager) { create(:user, :manager) }

    it "returns a success response" do
      post "/api/warehouses/assign_manager/#{warehouse.id}", params: { manager_id: manager.id }, headers: auth_headers(user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq("Success")
      expect(json_response['data']).to be_present

      warehouse.reload
      expect(warehouse.manager_id).to eq(manager.id)
    end

    it "returns a not found response when manager does not exist" do
      post "/api/warehouses/assign_manager/#{warehouse.id}", params: { manager_id: 999999 }, headers: auth_headers(user)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /unassign_manager" do
    let(:user) { create(:user, :plant_manager) }
    let(:manager) { create(:user, :manager) }
    let(:warehouse) { create(:warehouse, manager: manager) }

    it "returns a success response" do
      post "/api/warehouses/unassign_manager/#{warehouse.id}", params: { manager_id: manager.id }, headers: auth_headers(user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq("Success")

      warehouse.reload
      expect(warehouse.manager_id).to be_nil
    end

    it "returns a not found response when manager does not exist" do
      post "/api/warehouses/unassign_manager/#{warehouse.id}", params: { manager_id: 999999 }, headers: auth_headers(user)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /assign_worker" do
    let(:user) { create(:user, :plant_manager) }
    let(:warehouse) { create(:warehouse) }
    let(:worker) { create(:user, :warehouse_worker) }

    it "returns a success response" do
      post "/api/warehouses/assign_worker/#{warehouse.id}", params: { worker_id: worker.id }, headers: auth_headers(user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq("Success")

      warehouse.reload
      expect(warehouse.workers).to include(worker)
    end

    it "returns a not found response when worker does not exist" do
      post "/api/warehouses/assign_worker/#{warehouse.id}", params: { worker_id: 999999 }, headers: auth_headers(user)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /unassign_worker" do
    let(:user) { create(:user, :plant_manager) }
    let(:warehouse) { create(:warehouse) }
    let(:worker) { create(:user, :warehouse_worker) }

    before do
      warehouse.workers << worker
    end

    it "returns a success response" do
      post "/api/warehouses/unassign_worker/#{warehouse.id}", params: { worker_id: worker.id }, headers: auth_headers(user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq("Success")

      warehouse.reload
      expect(warehouse.workers).not_to include(worker)
    end

    it "returns a not found response when worker does not exist" do
      post "/api/warehouses/unassign_worker/#{warehouse.id}", params: { worker_id: 999999 }, headers: auth_headers(user)

      expect(response).to have_http_status(:not_found)
    end
  end
end
