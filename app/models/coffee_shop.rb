class CoffeeShop < ApplicationRecord
  # Associations
  has_many :reviews, dependent: :destroy
  has_many :users, through: :reviews  # For user-review relationships

  # Validations (expanded)
  validates :name, presence: true, length: { maximum: 100 }
  validates :city, presence: true
  validates :country, presence: true
  validates :latitude, numericality: {
    greater_than_or_equal_to: -90,
    less_than_or_equal_to: 90,
    allow_nil: true  # In case you have shops without coordinates
  }
  validates :longitude, numericality: {
    greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180,
    allow_nil: true
  }

  # Scopes
  scope :highly_rated, -> { where('rating >= ?', 4) }
  scope :with_reviews, -> { joins(:reviews).distinct }
  scope :by_country, ->(country) { where(country: country) if country.present? }

  # Search functionality (improved)
  def self.search(query)
    where("name ILIKE ? OR city ILIKE ? OR country ILIKE ?",
          "%#{query}%", "%#{query}%", "%#{query}%")
  end

  # Instance methods
  def average_rating
    reviews.average(:rating)&.round(1) || 0
  end

  def review_count
    reviews.count
  end

  def nearby_shops(radius_km: 5, limit: 5)
    return CoffeeShop.none unless latitude && longitude

    CoffeeShop.where.not(id: id)
              .select("*, (6371 * acos(cos(radians(#{latitude})) * cos(radians(latitude)) *
                      cos(radians(longitude) - radians(#{longitude})) +
                      sin(radians(#{latitude})) * sin(radians(latitude)))) AS distance")
              .having("distance < ?", radius_km)
              .order('distance')
              .limit(limit)
  end

  def update_average_rating
    update_column(:rating, average_rating)
  end

  # For display purposes
  def display_address
    [address, city, country].compact.join(', ')
  end
end