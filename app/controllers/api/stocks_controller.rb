class Api::StocksController < ApplicationController
    before_action :set_stock, only: [ :show ]

    def index
        per_page = params[:per] || 10
        @stocks = Stock.page(params[:page]).per(per_page)
        render_success(data: @stocks)
    end

    def show
        render_success(data: @stock)
    end

    def by_warehouse
        per_page = params[:per] || 10
        @stocks = Stock.where(warehouse_id: params[:warehouse_id])
        @stocks_paginated = @stocks.page(params[:page]).per(per_page)
        render_success(data: @stocks_paginated)
    end

    def by_product
        per_page = params[:per] || 10
        @stocks = Stock.where(product_id: params[:product_id])
        @stocks_paginated = @stocks.page(params[:page]).per(per_page)
        render_success(data: @stocks_paginated)
    end

    private

    def set_stock
        @stock = Stock.find(params[:id])
    end

    def stock_params
        params.require(:stock).permit(:quantity)
    end
end
