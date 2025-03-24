class CoffeeReview < ApplicationRecord
  belongs_to :coffee_brand
  belongs_to :user
end
