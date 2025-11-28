require 'rails_helper'

RSpec.describe "Api::ProductsControllers", type: :request do
  let(:plant_manager) do
    User.find_or_create_by!(
      email: "pm@test.com",
      password: "password123",
      full_name: "Plant Manager",
      role: :plant_manager
    )
  end

  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "GET /show" do
    it "returns a success response" do
      get "/api/products/1"
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /create" do
    it "returns a success response" do
      post "/api/products", params: { product: { name: "Product 1", description: "Description 1", sku: "SKU1" } }
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT /update" do
    it "returns a success response" do
      put "/api/products/1", params: { product: { name: "Product 1", description: "Description 1", sku: "SKU1" } }
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /destroy" do
    it "returns a success response" do
      delete "/api/products/1"
      expect(response).to have_http_status(200)
    end
  end
end
