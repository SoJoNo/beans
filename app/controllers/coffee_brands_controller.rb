class CoffeeBrandsController < ApplicationController
  def index
    @coffee_brands = CoffeeBrand.all.page(params[:page])
  end

  def show
    @coffee_brand = CoffeeBrand.find(params[:id])
  end
end