class Api::WarehousesController < ApplicationController
    before_action :set_warehouse, only: [ :show, :update, :destroy, :assign_manager, :unassign_manager, :assign_worker, :unassign_worker ]
    before_action :require_plant_manager, only: [ :create, :update, :destroy, :assign_manager, :unassign_manager, :assign_worker, :unassign_worker ]

    def index
        @warehouses = Warehouse.page(params[:page]).per(10)
        render_success(data: @warehouses)
    end

    def show
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
        @manager = User.find(params[:manager_id])
        @warehouse.update(manager: @manager)
        render_success(data: @warehouse)
    end

    def unassign_manager
        @manager = User.find(params[:manager_id])
        @warehouse.update(manager: nil)
        render_success(data: @warehouse)
    end

    def assign_worker
        @worker = User.find(params[:worker_id])
        @warehouse.workers << @worker
        render_success(data: @warehouse)
    end

    def unassign_worker
        @worker = User.find(params[:worker_id])
        @warehouse.workers.delete(@worker)
        render_success(data: @warehouse)
    end

    private

    def set_warehouse
        @warehouse = Warehouse.find(params[:id])
    end

    def warehouse_params
        params.require(:warehouse).permit(:name, :location)
    end

    def require_plant_manager
        unless current_user.role == "plant_manager"
            render_error(errors: "You are not authorized to access this resource")
        end
    end
end
