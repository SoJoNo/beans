class CreateCoffeeBrands < ActiveRecord::Migration[8.0]
  def change
    create_table :coffee_brands do |t|
      t.string :name
      t.string :roaster
      t.string :origin
      t.string :roast_level

      t.timestamps
    end
  end
end
