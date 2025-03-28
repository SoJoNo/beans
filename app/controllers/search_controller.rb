class SearchController < ApplicationController
  def index
    @query = params[:query]&.strip

    # Handle empty search
    if @query.blank?
      redirect_to root_path, alert: "Please enter a search term"
      return
    end

    # Perform searches
    @coffee_shops = CoffeeShop.search(@query).limit(5)
    @coffee_brands = CoffeeBrand.search(@query).limit(5)

    # Handle no results
    if @coffee_shops.empty? && @coffee_brands.empty?
      flash.now[:notice] = "No results found for '#{@query}'"
    end
  end
end