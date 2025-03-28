class Review < ApplicationRecord
  belongs_to :coffee_shop
  belongs_to :user, optional: true

  validates :user, presence: true
  validates :created_at, presence: true
  validates :rating,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5
    }
  validates :content, presence: true, length: { minimum: 10 }

  before_validation :set_default_timestamp, on: :create
  before_validation :ensure_user

  after_save :update_coffee_shop_rating
  after_destroy :update_coffee_shop_rating

  private

  def set_default_timestamp
    self.created_at ||= Time.current
  end

  def ensure_user
    self.user ||= User.anonymous_user # Implement this in User model if needed
  end

  def update_coffee_shop_rating
    coffee_shop.update_rating_from_reviews
  end
end