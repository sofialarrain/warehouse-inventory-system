class Api::InventoryMovementsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_inventory_movement, only: [ :show, :update, :destroy ]

    def index
        @inventory_movements = InventoryMovement.page(params[:page]).per(10)
        render_success(data: @inventory_movements)
    end

    def register_entry
        unless check_warehouse_access(params[:warehouse_id])
            render_error(errors: ["You are not authorized to access this resource"])
            return
        end

        stock = Stock.find_or_initialize_by(
            warehouse_id: params[:warehouse_id],
            product_id: params[:product_id]
        )
        stock.quantity = (stock.quantity || 0) + params[:quantity]
        stock.save

        create_movement(
            movement_type: :entry,
            destination_warehouse_id: params[:warehouse_id]
        )
    end

    def register_exit
        unless check_warehouse_access(params[:warehouse_id])
            render_error(errors: ["You are not authorized to access this resource"])
            return
        end

        stock = Stock.find_by(
            warehouse_id: params[:warehouse_id],
            product_id: params[:product_id]
        )

        if stock.nil?
            render_error(errors: ["Stock not found"])
            return
        end
        if stock.quantity < params[:quantity]
            render_error(errors: ["Insufficient stock"])
            return
        end

        stock.quantity = stock.quantity - params[:quantity]
        stock.save

        create_movement(movement_type: :exit, source_warehouse_id: params[:warehouse_id])
    end

    def register_transfer
        unless check_warehouse_access(params[:source_warehouse_id])
            render_error(errors: ["You are not authorized to access this resource"])
            return
        end

        unless check_warehouse_access(params[:destination_warehouse_id])
            render_error(errors: ["You are not authorized to access this resource"])
            return
        end

        source_stock = Stock.find_by(
            warehouse_id: params[:source_warehouse_id],
            product_id: params[:product_id]
        )

        if source_stock.nil?
            render_error(errors: ["Stock not found"])
            return
        end
        if source_stock.quantity < params[:quantity]
            render_error(errors: ["Insufficient stock"])
            return
        end

        source_stock.quantity = source_stock.quantity - params[:quantity]
        source_stock.save

        destination_stock = Stock.find_or_initialize_by(
            warehouse_id: params[:destination_warehouse_id],
            product_id: params[:product_id]
        )
        destination_stock.quantity = destination_stock.quantity + params[:quantity]
        destination_stock.save

        create_movement(
            movement_type: :transfer,
            source_warehouse_id: params[:source_warehouse_id],
            destination_warehouse_id: params[:destination_warehouse_id]
        )
    end

    def movement_history
        @inventory_movements = InventoryMovement.where(product_id: params[:product_id])
        @inventory_movements_paginated = @inventory_movements.page(params[:page]).per(10)
        render_success(data: @inventory_movements_paginated)
    end

    private

    def set_inventory_movement
        @inventory_movement = InventoryMovement.find(params[:id])
    end

    def inventory_movement_params
        params.require(:inventory_movement).permit(:quantity, :movement_type, :source_warehouse_id, :destination_warehouse_id)
    end

    def create_movement(movement_type:, source_warehouse_id: nil, destination_warehouse_id: nil)
        @inventory_movement = InventoryMovement.new(
            product_id: params[:product_id],
            source_warehouse_id: source_warehouse_id,
            destination_warehouse_id: destination_warehouse_id,
            user: current_user,
            quantity: params[:quantity],
            movement_type: movement_type
        )

        if @inventory_movement.save
            render_success(data: @inventory_movement)
        else
            render_error(errors: @inventory_movement.errors.full_messages)
        end
    end

    def check_warehouse_access(warehouse_id)
        if current_user&.plant_manager?
            return true
        end

        if current_user&.manager?
            return current_user.managed_warehouses.exists?(id: warehouse_id)
        end

        if current_user&.warehouse_worker?
            warehouse = Warehouse.find(id:warehouse_id)
            return false unless warehouse
            return current_user.assigned_warehouses.include?(warehouse)
        end

        return false
    end
end
