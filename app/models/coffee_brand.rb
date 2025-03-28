class CoffeeBrand < ApplicationRecord
  has_many :coffee_reviews
  validates :name, :roaster, presence: true

  def average_rating
    coffee_reviews.average(:rating)&.round(1) || 0
  end

  def display_rating
    return 0 if average_rating.nil?
    (average_rating.to_f / 20).round(1) # Convert 1-100 average to 1-5 scale
  end

  def stars
    return 0 if average_rating.nil?
    (average_rating.to_f / 20).round # Whole number for stars
  end

  def self.search(query)
    return all unless query.present?
    where("LOWER(name) LIKE LOWER(?) OR LOWER(roaster) LIKE LOWER(?) OR LOWER(origin) LIKE LOWER(?)",
          "%#{query}%", "%#{query}%", "%#{query}%")
  end

  def similar_products(limit: 4)
    return [] unless origin.present? || roast_level.present?

    query = CoffeeBrand.where.not(id: id)
    query = query.where(origin: origin) if origin.present?
    query = query.or(
      CoffeeBrand.where(roast_level: roast_level)
    ) if roast_level.present?

    query.order('RANDOM()').limit(limit)
  end
end
