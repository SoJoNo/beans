class CreateCoffeeShops < ActiveRecord::Migration[8.0]
  def change
    create_table :coffee_shops do |t|
      t.string :name
      t.string :city
      t.string :country
      t.float :rating
      t.boolean :specialty_coffee

      t.timestamps
    end
  end
end
