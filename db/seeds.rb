# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'csv'
require 'faker'
require 'httparty'

# Source 1: Kaggle CSV
csv_data = CSV.read('db/coffee_shops.csv', headers: true)
csv_data.each do |row|
  CoffeeShop.create!(
    name: row['name'],
    city: row['city'],
    country: row['country'],
    rating: row['rating'].to_f,
    specialty_coffee: row['specialty_coffee'] == 'Yes'
  )
end

# Source 2: Yelp API (mock)
CoffeeShop.first(5).each do |shop|
  response = HTTParty.get("https://api.yelp.com/v3/businesses/#{shop.name.downcase.gsub(' ', '-')}",
    headers: { "Authorization" => "Bearer YOUR_API_KEY" }
  )
  shop.update!(
    hours: response['hours'],
    price_range: response['price']
  )
end

# Source 3: Faker (Users + Reviews)
50.times do
  user = User.create!(
    username: Faker::Internet.username,
    email: Faker::Internet.email
  )

  CoffeeShop.all.sample(5).each do |shop|
    Review.create!(
      content: Faker::Restaurant.review,
      rating: rand(1..5),
      coffee_shop: shop,
      user: user
    )
  end
end