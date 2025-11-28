class Api::StocksController < ApplicationController
    before_action :set_stock, only: [ :show, :update, :destroy ]

    def index
        @stocks = Stock.page(params[:page]).per(10)
        render_success(data: @stocks)
    end

    def show
        render_success(data: @stock)
    end

    def by_warehouse
        @stocks = Stock.where(warehouse_id: params[:warehouse_id])
        render_success(data: @stocks)
    end

    def by_product
        @stocks = Stock.where(product_id: params[:product_id])
        render_success(data: @stocks)
    end

    private

    def set_stock
        @stock = Stock.find(params[:id])
    end

    def stock_params
        params.require(:stock).permit(:quantity)
    end
end
