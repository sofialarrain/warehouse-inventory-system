require 'rails_helper'

RSpec.describe "Api::StocksControllers", type: :request do
  let(:plant_manager) do
    User.create!(
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
      get "/api/stocks/1"
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /by_warehouse" do
    it "returns a success response" do
      get "/api/stocks/by_warehouse/1"
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /by_product" do
    it "returns a success response" do
      get "/api/stocks/by_product/1"
      expect(response).to have_http_status(200)
    end
  end
end
