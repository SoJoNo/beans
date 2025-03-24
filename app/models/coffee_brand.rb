class CoffeeBrand < ApplicationRecord
  has_many :coffee_reviews
  validates :name, :roaster, presence: true
end
