class Api::InventoryMovementsController < ApplicationController
    before_action :set_inventory_movement, only: [ :show, :update, :destroy ]

    def index
        @inventory_movements = InventoryMovement.all
        render_success(data: @inventory_movements)
    end

    def register_entry
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
        stock = Stock.find_by(
            warehouse_id: params[:warehouse_id],
            product_id: params[:product_id]
        )
        stock.quantity = stock.quantity - params[:quantity]
        stock.save

        create_movement(
            movement_type: :exit,
            source_warehouse_id: params[:warehouse_id]
        )
    end

    def register_transfer
        source_stock = Stock.find_by(
            warehouse_id: params[:source_warehouse_id],
            product_id: params[:product_id]
        )
        source_stock.quantity = source_stock.quantity - params[:quantity]
        source_stock.save

        destination_stock = Stock.find_or_initialize_by(
            warehouse_id: params[:destination_warehouse_id],
            product_id: params[:product_id]
        )
        destination_stock.quantity = (destination_stock.quantity || 0) + params[:quantity]
        destination_stock.save

        create_movement(
            movement_type: :transfer,
            source_warehouse_id: params[:source_warehouse_id],
            destination_warehouse_id: params[:destination_warehouse_id]
        )
    end

    def movement_history
        @inventory_movements = InventoryMovement.where(product_id: params[:product_id])
        render_success(data: @inventory_movements)
    end

    private

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
end
