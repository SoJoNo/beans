class CoffeeProductsController < ApplicationController
  def index
    @coffee_products = CoffeeProduct.all.page(params[:page])
  end

  def show
    @coffee_product = CoffeeProduct.find(params[:id])
  end
end