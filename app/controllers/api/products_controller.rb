class Api::ProductsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_product, only: [ :show, :update, :destroy ]

    def index
        @products = Product.page(params[:page]).per(10)
        render_success(data: @products)
    end

    def show
        render_success(data: @product)
    end

    def create
        @product = Product.new(product_params)
        if @product.save
            render_success(data: @product)
        else
            render_error(errors: @product.errors.full_messages)
        end
    end

    def update
        if @product.update(product_params)
            render_success(data: @product)
        else
            render_error(errors: @product.errors.full_messages)
        end
    end

    def destroy
        if @product.destroy
            render_success(message: "Product deleted successfully")
        else
            render_error(errors: @product.errors.full_messages)
        end
    end

    private

    def set_product
        @product = Product.find(params[:id])
    end

    def product_params
        params.require(:product).permit(:name, :description, :sku)
    end
end
