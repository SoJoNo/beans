class CoffeeShop < ApplicationRecord
  has_many :reviews
  validates :name, presence: true
validates :rating, numericality: { in: 1..5 }
end
