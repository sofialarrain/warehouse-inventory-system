require 'rails_helper'

RSpec.describe "Api::ProductsControllers", type: :request do
  describe "GET /index" do
    let(:user) { create(:user, :plant_manager) }
    let(:product) { create(:product) }

    before do
      create_list(:product, 3)
    end

    it "returns a success response" do
      get "/api/products", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.name)
    end

    it "returns paginated results" do
      get "/api/products", params: { page: 1, per: 2 }, headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.name)
    end
  end

  describe "GET /show" do
    let(:user) { create(:user, :plant_manager) }
    let(:product) { create(:product) }

    it "returns a success response" do
      get "/api/products/#{product.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.name)
    end

    it "returns a not found response" do
      get "/api/products/999999", headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /create" do
    let(:user) { create(:user, :plant_manager) }
    let(:product) { create(:product) }

    it "returns a success response" do
      post "/api/products", params: { product: { name: "Product 1", description: "Description 1", sku: "SKU1" } }, headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq("Success")
      expect(json_response['data']).to be_present
      expect(json_response['data']['name']).to eq("Product 1")
      expect(json_response['data']['sku']).to eq("SKU1")
    end

    it "returns a unprocessable entity response" do
      post "/api/products", params: { product: { name: "", description: "Description 1", sku: "SKU1" } }, headers: auth_headers(user)
      expect(response).to have_http_status(:unprocessable_entity)
      
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to be_present
      expect(json_response['errors']).to include(match(/Name.*blank/i))
    end
  end

  describe "PUT /update" do
    let(:user) { create(:user, :plant_manager) }
    let(:product) { create(:product, name: "Product 1", sku: "SKU1") }

    it "returns a success response" do
      put "/api/products/#{product.id}", 
          params: { product: { name: "Updated Product", description: "Updated Description", sku: "UPDATED" } },
          headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq("Success")
      expect(json_response['data']).to be_present
      expect(json_response['data']['name']).to eq("Updated Product")
      expect(json_response['data']['sku']).to eq("UPDATED")
      
      product.reload
      expect(product.name).to eq("Updated Product")
    end

    it "returns a unprocessable entity response when validation fails" do
      put "/api/products/#{product.id}", 
          params: { product: { name: "", description: "Updated Description", sku: "UPDATED" } },
          headers: auth_headers(user)
      
      expect(response).to have_http_status(:unprocessable_entity)
      
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to be_present
    end

    it "returns a not found response for non-existent product" do
      put "/api/products/999999", 
          params: { product: { name: "Updated Product" } },
          headers: auth_headers(user)
      
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /destroy" do
    let(:user) { create(:user, :plant_manager) }
    let(:product) { create(:product) }

    it "returns a success response" do
      delete "/api/products/#{product.id}", headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq("Product deleted successfully")
      
      expect(Product.find_by(id: product.id)).to be_nil
    end

    it "returns a not found response for non-existent product" do
      delete "/api/products/999999", headers: auth_headers(user)
      
      expect(response).to have_http_status(:not_found)
    end
  end
end
