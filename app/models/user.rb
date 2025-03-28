class User < ApplicationRecord
  has_many :reviews
  has_many :coffee_reviews

  validates :username, presence: true, uniqueness: true

  def self.anonymous
    find_or_create_by!(username: "Anonymous", email: "anonymous@example.com") do |user|
      user.password = SecureRandom.hex
    end
  end
end
