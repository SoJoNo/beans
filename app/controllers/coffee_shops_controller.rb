class CoffeeShopsController < ApplicationController
  def index
    @coffee_shops = CoffeeShop.all.page(params[:page])
  end

  def show
    @coffee_shop = CoffeeShop.find(params[:id])
    @review = @coffee_shop.reviews.new
  end
end