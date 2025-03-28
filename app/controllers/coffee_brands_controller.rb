class CoffeeBrandsController < ApplicationController
  def index
    @search_term = params[:search]
    @records = CoffeeBrand.search(@search_term).page(params[:page])
    @coffee_brands = CoffeeBrand.includes(:coffee_reviews).page(params[:page])

    # Apply roast level filter if present
    if params[:roast_level].present? && params[:roast_level] != 'All'
      @coffee_brands = @coffee_brands.where(roast_level: params[:roast_level])
    end

    # Apply origin filter if present
    if params[:origin].present? && params[:origin] != 'All'
      @coffee_brands = @coffee_brands.where(origin: params[:origin])
    end
  end

  def show
    @coffee_brand = CoffeeBrand.find(params[:id])
    @similar_products = @coffee_brand.similar_products || []
  rescue ActiveRecord::RecordNotFound
    redirect_to coffee_brands_path, alert: "Coffee brand not found"
  end
end