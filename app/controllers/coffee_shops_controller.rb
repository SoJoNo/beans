class CoffeeShopsController < ApplicationController
  def index
    @search_term = params[:search]
    @records = CoffeeShop.search(@search_term).page(params[:page])
    @coffee_shops = CoffeeShop.all.page(params[:page])

    # Apply country filter if present
    if params[:country].present? && params[:country] != 'All Countries'
      @coffee_shops = @coffee_shops.where(country: params[:country])
    end

    # Apply minimum rating filter if present
    if params[:min_rating].present? && params[:min_rating].to_f > 0
      @coffee_shops = @coffee_shops.where('rating >= ?', params[:min_rating])
    end

  end

  def show
    @coffee_shop = CoffeeShop.friendly.find(params[:id])
    @review = @coffee_shop.reviews.new
    @nearby_shops = @coffee_shop.nearby_shops || []
  rescue ActiveRecord::RecordNotFound
    redirect_to coffee_shops_path, alert: "Coffee shop not found"

    if @coffee_shop.nil?
      redirect_to coffee_shops_path, alert: "Coffee shop not found"
      return
    end
  end

end