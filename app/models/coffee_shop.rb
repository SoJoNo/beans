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
    return all unless query.present?
    where("LOWER(name) LIKE LOWER(?) OR LOWER(city) LIKE LOWER(?) OR LOWER(country) LIKE LOWER(?)",
          "%#{query}%", "%#{query}%", "%#{query}%")
  end

  # Instance methods
  def average_rating
    reviews.average(:rating).to_f.round(1)
  end

  def review_count
    reviews.count
  end

  def nearby_shops(radius_km: 5, limit: 5)
    return [] unless latitude && longitude

    CoffeeShop.find_by_sql([<<-SQL, latitude: latitude, longitude: longitude, radius: radius_km, limit: limit, current_id: id])
      SELECT *,
      (6371 * acos(
        cos(radians(:latitude)) *
        cos(radians(latitude)) *
        cos(radians(longitude) - radians(:longitude)) +
        sin(radians(:latitude)) *
        sin(radians(latitude))
      )) AS distance
      FROM coffee_shops
      WHERE id != :current_id
      AND distance < :radius
      ORDER BY distance
      LIMIT :limit
    SQL
  end

  after_save :update_rating_from_reviews, if: :saved_change_to_rating?

  def update_rating_from_reviews
    new_rating = reviews.average(:rating).to_f.round(1)
    update_column(:rating, new_rating)
  end

  # For display purposes
  def display_address
    [address, city, country].compact.join(', ')
  end

  extend FriendlyId
  friendly_id :name, use: :slugged
end