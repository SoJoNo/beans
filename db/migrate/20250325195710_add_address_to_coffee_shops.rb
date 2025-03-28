class AddAddressToCoffeeShops < ActiveRecord::Migration[8.0]
  def change
    add_column :coffee_shops, :address, :string
  end
end
