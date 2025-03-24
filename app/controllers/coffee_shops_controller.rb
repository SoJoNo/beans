# app/controllers/coffee_shops_controller.rb
def index
  @coffee_shops = CoffeeShop.all
  @coffee_shop = CoffeeShop.find(params[:id])
end