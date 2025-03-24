class UpdateCoffeeShopsForStarbucksData < ActiveRecord::Migration[8.0]
  def change
    add_column :coffee_shops, :latitude, :float
    add_column :coffee_shops, :longitude, :float
    add_column :coffee_shops, :phone, :string
    remove_column :coffee_shops, :specialty_coffee
  end
end
