class AddSlugToCoffeeShops < ActiveRecord::Migration[8.0]
  def change
    add_column :coffee_shops, :slug, :string
    add_index :coffee_shops, :slug, unique: true
  end
end
