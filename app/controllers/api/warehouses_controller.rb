class Api::WarehousesController < ApplicationController
    before_action :set_warehouse, only: [ :show, :update, :destroy ]

    def index
        @warehouses = Warehouse.all
        render_success(data: @warehouses)
    end

    def show
        @warehouse = Warehouse.find(params[:id])
        render_success(data: @warehouse)
    end

    def create
        @warehouse = Warehouse.new(warehouse_params)
        if @warehouse.save
            render_success(data: @warehouse)
        else
            render_error(errors: @warehouse.errors.full_messages)
        end
    end

    def update
        if @warehouse.update(warehouse_params)
            render_success(data: @warehouse)
        else
            render_error(errors: @warehouse.errors.full_messages)
        end
    end


    def destroy
        if @warehouse.destroy
            render_success(message: "Warehouse deleted successfully")
        else
            render_error(errors: @warehouse.errors.full_messages)
        end
    end

    def assign_manager
        @warehouse = Warehouse.find(params[:id])
        @manager = User.find(params[:manager_id])
        @warehouse.update(manager: @manager)
        render_success(data: @warehouse)
    end

    def unassign_manager
        @warehouse = Warehouse.find(params[:id])
        @manager = User.find(params[:manager_id])
        @warehouse.update(manager: nil)
        render_success(data: @warehouse)
    end

    def assign_worker
        @warehouse = Warehouse.find(params[:id])
        @worker = User.find(params[:worker_id])
        @warehouse.workers << @worker
        render_success(data: @warehouse)
    end

    def unassign_worker
        @warehouse = Warehouse.find(params[:id])
        @worker = User.find(params[:worker_id])
        @warehouse.workers.delete(@worker)
        render_success(data: @warehouse)
    end
end
