class Api::StocksController < ApplicationController
    before_action :set_stock, only: [ :show, :update, :destroy ]

    def index
        @stocks = Stock.all
        render_success(data: @stocks)
    end
    
    def show
        @stock = Stock.find(params[:id])
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
end
