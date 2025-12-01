require 'rails_helper'

RSpec.describe "Api::StocksControllers", type: :request do
  describe "GET /index" do
    let(:user) { create(:user, :plant_manager) }
    let(:warehouse) { create(:warehouse) }
    let(:product) { create(:product) }

    before do
      create_list(:stock, 3)
    end

    it "returns a success response" do
      get "/api/stocks", headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq("Success")
      expect(json_response['data']).to be_present
      expect(json_response['data'].length).to eq(3)
    end

    it "returns paginated results" do
      get "/api/stocks", params: { page: 1, per: 2 }, headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to be_present
      expect(json_response['data'].length).to eq(2)
    end
  end

  describe "GET /show" do
    let(:user) { create(:user, :plant_manager) }
    let(:stock) { create(:stock) }

    it "returns a success response" do
      get "/api/stocks/#{stock.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(stock.quantity.to_s)
    end
    
    it "returns a not found response" do
      get "/api/stocks/999999", headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /by_warehouse" do
    let(:user) { create(:user, :plant_manager) }
    let(:warehouse) { create(:warehouse) }
    let(:other_warehouse) { create(:warehouse) }
    let(:product1) { create(:product) }
    let(:product2) { create(:product) }
    let(:product3) { create(:product) }

    before do
      create(:stock, warehouse: warehouse, product: product1, quantity: 10)
      create(:stock, warehouse: warehouse, product: product2, quantity: 20)
      create(:stock, warehouse: warehouse, product: product3, quantity: 30)
      create(:stock, warehouse: other_warehouse, product: product1, quantity: 5)
    end
    
    it "returns stocks for a specific warehouse" do
      get "/api/stocks/by_warehouse/#{warehouse.id}", headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to be_present
      expect(json_response['data'].length).to eq(3)
      json_response['data'].each do |stock_data|
        expect(stock_data['warehouse_id']).to eq(warehouse.id)
      end
    end
    
    it "returns paginated results" do
      get "/api/stocks/by_warehouse/#{warehouse.id}", params: { page: 1, per: 2 }, headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to be_present
      expect(json_response['data'].length).to eq(2)
    end

    it "returns empty array for non-existent warehouse" do
      get "/api/stocks/by_warehouse/999999", headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to be_an(Array)
      expect(json_response['data'].length).to eq(0)
    end
  end

  describe "GET /by_product" do
    let(:user) { create(:user, :plant_manager) }
    let(:warehouse1) { create(:warehouse) }
    let(:warehouse2) { create(:warehouse) }
    let(:warehouse3) { create(:warehouse) }
    let(:product) { create(:product) }
    let(:other_product) { create(:product) }

    before do
      create(:stock, warehouse: warehouse1, product: product, quantity: 10)
      create(:stock, warehouse: warehouse2, product: product, quantity: 20)
      create(:stock, warehouse: warehouse3, product: product, quantity: 30)
      create(:stock, warehouse: warehouse1, product: other_product, quantity: 5)
    end

    it "returns stocks for a specific product" do
      get "/api/stocks/by_product/#{product.id}", headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to be_present
      expect(json_response['data'].length).to eq(3)
      json_response['data'].each do |stock_data|
        expect(stock_data['product_id']).to eq(product.id)
      end
    end

    it "returns paginated results" do
      get "/api/stocks/by_product/#{product.id}", params: { page: 1, per: 2 }, headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to be_present
      expect(json_response['data'].length).to eq(2)
    end

    it "returns empty array for non-existent product" do
      get "/api/stocks/by_product/999999", headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to be_an(Array)
      expect(json_response['data'].length).to eq(0)
    end
  end
end
