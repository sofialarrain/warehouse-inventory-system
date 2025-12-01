require 'rails_helper'

RSpec.describe "Api::InventoryMovementsControllers", type: :request do
  describe "GET /index" do
    let(:user) { create(:user, :plant_manager) }
    let(:product) { create(:product) }
    let(:warehouse) { create(:warehouse) }

    before do
      create_list(:inventory_movement, 3, :entry, user: user, product: product, destination_warehouse: warehouse)
      create_list(:inventory_movement, 2, :exit, user: user, product: product, source_warehouse: warehouse)
    end

    it "returns a success response" do
      get "/api/inventory_movements", headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['data'].length).to eq(5)
    end

    it "returns paginated results" do
      get "/api/inventory_movements", params: { page: 1, per: 2 }, headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to be_present
      expect(json_response['data'].length).to eq(2)
    end
  end

  describe "POST /register_entry" do
    let(:warehouse) { create(:warehouse) }
    let(:product) { create(:product) }

    context "as plant_manager" do
      let(:user) { create(:user, :plant_manager) }

      it "creates a new stock entry and inventory movement" do
        post "/api/inventory/entry", 
             params: { 
               warehouse_id: warehouse.id, 
               product_id: product.id, 
               quantity: 10 
             },
             headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        stock = Stock.find_by(warehouse_id: warehouse.id, product_id: product.id)
        expect(stock).to be_present
        expect(stock.quantity).to eq(10)

        movement = InventoryMovement.last
        expect(movement).to be_present
        expect(movement.movement_type).to eq("entry")
        expect(movement.destination_warehouse_id).to eq(warehouse.id)
        expect(movement.product_id).to eq(product.id)
        expect(movement.quantity).to eq(10)
        expect(movement.user_id).to eq(user.id)
      end

      it "updates existing stock when entry is made" do
        existing_stock = create(:stock, warehouse: warehouse, product: product, quantity: 50)

        post "/api/inventory/entry", 
             params: { 
               warehouse_id: warehouse.id, 
               product_id: product.id, 
               quantity: 20 
             },
             headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        
        existing_stock.reload
        expect(existing_stock.quantity).to eq(70)
      end
    end

    context "as manager with warehouse access" do
      let(:manager) { create(:user, :manager) }
      let(:warehouse) { create(:warehouse, manager: manager) }

      it "creates entry successfully" do
        post "/api/inventory/entry", 
             params: { 
               warehouse_id: warehouse.id, 
               product_id: product.id, 
               quantity: 15 
             },
             headers: auth_headers(manager)

        expect(response).to have_http_status(:ok)
        
        stock = Stock.find_by(warehouse_id: warehouse.id, product_id: product.id)
        expect(stock.quantity).to eq(15)
      end
    end

    context "as warehouse_worker with warehouse access" do
      let(:worker) { create(:user, :warehouse_worker) }
      let(:warehouse) { create(:warehouse) }

      before do
        create(:warehouse_assignment, user: worker, warehouse: warehouse)
      end

      it "creates entry successfully" do
        post "/api/inventory/entry", 
             params: { 
               warehouse_id: warehouse.id, 
               product_id: product.id, 
               quantity: 5 
             },
             headers: auth_headers(worker)

        expect(response).to have_http_status(:ok)
        
        stock = Stock.find_by(warehouse_id: warehouse.id, product_id: product.id)
        expect(stock.quantity).to eq(5)
      end
    end

    context "without warehouse access" do
      let(:worker) { create(:user, :warehouse_worker) }
      let(:warehouse) { create(:warehouse) }

      it "returns unauthorized error" do
        post "/api/inventory/entry", 
             params: { 
               warehouse_id: warehouse.id, 
               product_id: product.id, 
               quantity: 10 
             },
             headers: auth_headers(worker)

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("You are not authorized to access this resource")
      end
    end
  end

  describe "POST /register_exit" do
    let(:warehouse) { create(:warehouse) }
    let(:product) { create(:product) }

    context "as plant_manager" do
      let(:user) { create(:user, :plant_manager) }

      it "creates a stock exit and inventory movement" do
        initial_stock = create(:stock, warehouse: warehouse, product: product, quantity: 50)

        post "/api/inventory/exit", 
             params: { warehouse_id: warehouse.id, product_id: product.id, quantity: 10 },
             headers: auth_headers(user)

        expect(response).to have_http_status(:ok)

        initial_stock.reload
        expect(initial_stock.quantity).to eq(40)

        movement = InventoryMovement.last
        expect(movement).to be_present
        expect(movement.movement_type).to eq("exit")
        expect(movement.source_warehouse_id).to eq(warehouse.id)
        expect(movement.product_id).to eq(product.id)
        expect(movement.quantity).to eq(10)
        expect(movement.user_id).to eq(user.id)
      end

      it "returns error when stock does not exist" do
        post "/api/inventory/exit", 
             params: { warehouse_id: warehouse.id, product_id: product.id, quantity: 10 },
             headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Stock not found")
      end

      it "returns error when insufficient stock" do
        create(:stock, warehouse: warehouse, product: product, quantity: 5)

        post "/api/inventory/exit", 
             params: { warehouse_id: warehouse.id, product_id: product.id, quantity: 10 },
             headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Insufficient stock")
      end
    end

    context "as manager with warehouse access" do
      let(:manager) { create(:user, :manager) }
      let(:warehouse) { create(:warehouse, manager: manager) }

      it "creates a stock exit and inventory movement" do
        initial_stock = create(:stock, warehouse: warehouse, product: product, quantity: 30)

        post "/api/inventory/exit", 
             params: { warehouse_id: warehouse.id, product_id: product.id, quantity: 15 },
             headers: auth_headers(manager)

        expect(response).to have_http_status(:ok)

        initial_stock.reload
        expect(initial_stock.quantity).to eq(15)
      end
    end

    context "as warehouse_worker with warehouse access" do
      let(:worker) { create(:user, :warehouse_worker) }
      let(:warehouse) { create(:warehouse) }

      before do
        create(:warehouse_assignment, user: worker, warehouse: warehouse)
      end

      it "creates a stock exit and inventory movement" do
        initial_stock = create(:stock, warehouse: warehouse, product: product, quantity: 20)

        post "/api/inventory/exit", 
             params: { warehouse_id: warehouse.id, product_id: product.id, quantity: 5 },
             headers: auth_headers(worker)

        expect(response).to have_http_status(:ok)

        initial_stock.reload
        expect(initial_stock.quantity).to eq(15)
      end
    end

    context "without warehouse access" do
      let(:worker) { create(:user, :warehouse_worker) }
      let(:warehouse) { create(:warehouse) }

      it "returns unauthorized error" do
        create(:stock, warehouse: warehouse, product: product, quantity: 50)

        post "/api/inventory/exit", 
             params: { warehouse_id: warehouse.id, product_id: product.id, quantity: 10 },
             headers: auth_headers(worker)

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("You are not authorized to access this resource")
      end
    end
  end

  describe "POST /register_transfer" do
    let(:user) { create(:user, :plant_manager) }
    let(:source_warehouse) { create(:warehouse) }
    let(:destination_warehouse) { create(:warehouse) }
    let(:product) { create(:product) }

    context "as plant_manager" do
      it "creates a stock transfer and inventory movement" do
        source_stock = create(:stock, warehouse: source_warehouse, product: product, quantity: 10)
        
        post "/api/inventory/transfer", 
             params: { 
               source_warehouse_id: source_warehouse.id, 
               destination_warehouse_id: destination_warehouse.id, 
               product_id: product.id, 
               quantity: 5 
             },
             headers: auth_headers(user)

        expect(response).to have_http_status(:ok)

        source_stock.reload
        expect(source_stock.quantity).to eq(5)

        destination_stock = Stock.find_by(
          warehouse_id: destination_warehouse.id,
          product_id: product.id
        )
        expect(destination_stock).to be_present
        expect(destination_stock.quantity).to eq(5)

        movement = InventoryMovement.last
        expect(movement).to be_present
        expect(movement.movement_type).to eq("transfer")
        expect(movement.source_warehouse_id).to eq(source_warehouse.id)
        expect(movement.destination_warehouse_id).to eq(destination_warehouse.id)
        expect(movement.product_id).to eq(product.id)
        expect(movement.quantity).to eq(5)
        expect(movement.user_id).to eq(user.id)
      end
    end

    context "as manager with warehouse access" do
      let(:manager) { create(:user, :manager) }
      let(:source_warehouse) { create(:warehouse, manager: manager) }
      let(:destination_warehouse) { create(:warehouse, manager: manager) }

      it "creates a stock transfer and inventory movement" do
        source_stock = create(:stock, warehouse: source_warehouse, product: product, quantity: 10)

        post "/api/inventory/transfer", 
             params: { 
               source_warehouse_id: source_warehouse.id, 
               destination_warehouse_id: destination_warehouse.id, 
               product_id: product.id, 
               quantity: 5 
             },
             headers: auth_headers(manager)

        expect(response).to have_http_status(:ok)

        source_stock.reload
        expect(source_stock.quantity).to eq(5)

        destination_stock = Stock.find_by(
          warehouse_id: destination_warehouse.id,
          product_id: product.id
        )
        expect(destination_stock).to be_present
        expect(destination_stock.quantity).to eq(5)

        movement = InventoryMovement.last
        expect(movement).to be_present
        expect(movement.movement_type).to eq("transfer")
        expect(movement.source_warehouse_id).to eq(source_warehouse.id)
        expect(movement.destination_warehouse_id).to eq(destination_warehouse.id)
        expect(movement.product_id).to eq(product.id)
        expect(movement.quantity).to eq(5)
        expect(movement.user_id).to eq(manager.id)
      end
    end

    context "as warehouse_worker with warehouse access" do
      let(:worker) { create(:user, :warehouse_worker) }
      let(:source_warehouse) { create(:warehouse) }
      let(:destination_warehouse) { create(:warehouse) }

      before do
        create(:warehouse_assignment, user: worker, warehouse: source_warehouse)
        create(:warehouse_assignment, user: worker, warehouse: destination_warehouse)
      end

      it "creates a stock transfer and inventory movement" do
        source_stock = create(:stock, warehouse: source_warehouse, product: product, quantity: 10)

        post "/api/inventory/transfer", 
             params: { 
               source_warehouse_id: source_warehouse.id, 
               destination_warehouse_id: destination_warehouse.id, 
               product_id: product.id, 
               quantity: 5 
             },
             headers: auth_headers(worker)

        expect(response).to have_http_status(:ok)

        source_stock.reload
        expect(source_stock.quantity).to eq(5)

        destination_stock = Stock.find_by(
          warehouse_id: destination_warehouse.id,
          product_id: product.id
        )
        expect(destination_stock).to be_present
        expect(destination_stock.quantity).to eq(5)

        movement = InventoryMovement.last
        expect(movement).to be_present
        expect(movement.movement_type).to eq("transfer")
        expect(movement.source_warehouse_id).to eq(source_warehouse.id)
        expect(movement.destination_warehouse_id).to eq(destination_warehouse.id)
        expect(movement.product_id).to eq(product.id)
        expect(movement.quantity).to eq(5)
        expect(movement.user_id).to eq(worker.id)
      end
    end

    context "without warehouse access" do
      let(:worker) { create(:user, :warehouse_worker) }
      let(:source_warehouse) { create(:warehouse) }
      let(:destination_warehouse) { create(:warehouse) }

      it "returns unauthorized error" do
        create(:stock, warehouse: source_warehouse, product: product, quantity: 10)

        post "/api/inventory/transfer", 
             params: { 
               source_warehouse_id: source_warehouse.id, 
               destination_warehouse_id: destination_warehouse.id, 
               product_id: product.id, 
               quantity: 5 
             },
             headers: auth_headers(worker)

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("You are not authorized to access this resource")
      end
    end

    context "error cases" do
      it "returns error when source stock does not exist" do
        post "/api/inventory/transfer", 
             params: { 
               source_warehouse_id: source_warehouse.id, 
               destination_warehouse_id: destination_warehouse.id, 
               product_id: product.id, 
               quantity: 5 
             },
             headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Stock not found")
      end

      it "returns error when insufficient stock" do
        create(:stock, warehouse: source_warehouse, product: product, quantity: 3)

        post "/api/inventory/transfer", 
             params: { 
               source_warehouse_id: source_warehouse.id, 
               destination_warehouse_id: destination_warehouse.id, 
               product_id: product.id, 
               quantity: 5 
             },
             headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Insufficient stock")
      end
    end


  end

  describe "GET /movement_history" do
    let(:user) { create(:user, :plant_manager) }
    let(:product) { create(:product) }
    let(:warehouse) { create(:warehouse) }

    before do
      create_list(:inventory_movement, 3, :entry, user: user, product: product, destination_warehouse: warehouse)
      create_list(:inventory_movement, 2, :exit, user: user, product: product, source_warehouse: warehouse)
      other_product = create(:product)
      create_list(:inventory_movement, 2, :entry, user: user, product: other_product, destination_warehouse: warehouse)
    end

    it "returns a success response" do
      get "/api/inventory/history/#{product.id}", headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq("Success")
      expect(json_response['data']).to be_present
      expect(json_response['data'].length).to eq(5)
    end

    it "returns only movements for the specified product" do
      get "/api/inventory/history/#{product.id}", headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      movements = json_response['data']
      expect(movements.length).to eq(5)
      movements.each do |movement|
        expect(movement['product_id']).to eq(product.id)
      end
    end

    it "returns paginated results" do
      get "/api/inventory/history/#{product.id}", params: { page: 1, per: 2 }, headers: auth_headers(user)
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to be_present
      expect(json_response['data'].length).to eq(2)
    end
  end
end
