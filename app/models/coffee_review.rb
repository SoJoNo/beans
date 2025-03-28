class CoffeeReview < ApplicationRecord
  belongs_to :coffee_brand
  belongs_to :user

  validates :review, presence: true
  validates :rating, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }

  # Convert 1-100 rating to 1-5 scale for display
  def display_rating
    (rating.to_f / 20).round(1) # Shows decimal (e.g. 4.3)
  end

  # Whole number for star display
  def stars
    (rating.to_f / 20).round # Rounds to nearest integer
  end

  alias_attribute :content, :review
end
