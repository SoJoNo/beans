class CoffeeReview < ApplicationRecord
  belongs_to :coffee_brand
  belongs_to :user

  validates :rating, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5
  }
  validates :review, length: { minimum: 20 }
end
