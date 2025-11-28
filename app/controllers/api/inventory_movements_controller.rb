class Api::InventoryMovementsController < ApplicationController
    before_action :set_inventory_movement, only: [ :show, :update, :destroy ]

    def index
        @inventory_movements = InventoryMovement.all
        render_success(data: @inventory_movements)
    end

    def show_by_warehouse
        @inventory_movements = InventoryMovement.where(warehouse_id: params[:warehouse_id])
        render_success(data: @inventory_movements)
    end

    def show_by_product
        @inventory_movements = InventoryMovement.where(product_id: params[:product_id])
        render_success(data: @inventory_movements)
    end

    def register_entry
        stock = Stock.find_or_initialize_by(
            warehouse_id: params[:warehouse_id],
            product_id: params[:product_id]
        )
        stock.quantity = stock.quantity + params[:quantity]
        stock.save

        @inventory_movement = InventoryMovement.new(
            product_id: params[:product_id],
            destination_warehouse_id: params[:warehouse_id],
            user: current_user,
            quantity: params[:quantity],
            movement_type: :entry
        )

        if @inventory_movement.save
            render_success(data: @inventory_movement)
        else
            render_error(errors: @inventory_movement.errors.full_messages)
        end
    end

    def register_exit
        stock = Stock.find_by(
            warehouse_id: params[:warehouse_id],
            product_id: params[:product_id]
        )
        stock.quantity = stock.quantity - params[:quantity]
        stock.save

        @inventory_movement = InventoryMovement.new(
            product_id: params[:product_id],
            source_warehouse_id: params[:warehouse_id],
            user: current_user,
            quantity: params[:quantity],
            movement_type: :exit
        )

        if @inventory_movement.save
            render_success(data: @inventory_movement)
        else
            render_error(errors: @inventory_movement.errors.full_messages)
        end
    end

    def movement_history
        @inventory_movements = InventoryMovement.where(product_id: params[:product_id])
        render_success(data: @inventory_movements)
    end
end