class Review < ApplicationRecord
  belongs_to :coffee_shop
  belongs_to :user
  validates :rating, numericality: { in: 1..5 }
  validates :content, length: { minimum: 10 }
end
