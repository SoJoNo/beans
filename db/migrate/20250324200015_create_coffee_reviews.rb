class CreateCoffeeReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :coffee_reviews do |t|
      t.references :coffee_brand, null: false, foreign_key: true
      t.decimal :rating
      t.text :review
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
