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

# Clear existing data
CoffeeShop.destroy_all
User.destroy_all
Review.destroy_all
CoffeeBrand.destroy_all
CoffeeReview.destroy_all

# Import Starbucks data with error handling
skipped_rows = 0
successful_rows = 0

# Source 1: Kaggle CSV
CSV.foreach(Rails.root.join('db', 'starbucks_locations.csv'), headers: true, encoding: 'bom|utf-8') do |row|
  begin
    # Skip if essential fields are missing or malformed
    next unless row['City'].present? && row['Country'].present?

    # Clean numeric fields
    latitude = row['Latitude'].to_s.gsub(/[^0-9.-]/, '').to_f
    longitude = row['Longitude'].to_s.gsub(/[^0-9.-]/, '').to_f

    # Skip if coordinates are invalid
    next unless (-90..90).cover?(latitude) && (-180..180).cover?(longitude)

    CoffeeShop.create!(
      name: row['Store Name'].presence || "Starbucks #{row['City']}",
      city: row['City'],
      country: row['Country'],
      latitude: latitude,
      longitude: longitude,
      phone: row['Phone Number'].to_s.gsub(/[^0-9+]/, '').presence,
      rating: rand(3.0..5.0).round(1)
    )
    successful_rows += 1
  rescue => e
    puts "Skipping row due to error: #{e.message}"
    skipped_rows += 1
    next
  end
end

puts "\nImport complete!"
puts "Successfully imported #{successful_rows} coffee shops"
puts "Skipped #{skipped_rows} problematic rows"

# Import coffee brands and reviews
CSV.foreach(Rails.root.join('db', 'coffee_reviews.csv'), headers: true) do |row|
  # Find or create the coffee brand
  brand = CoffeeBrand.find_or_create_by!(
    name: row['name'],
    roaster: row['roaster'],
    origin: row['origin'],
    roast_level: row['roast_level']
  )

  # Create review (assign to random user)
  random_user = User.order('RANDOM()').first || User.create!(username: Faker::Internet.username, email: Faker::Internet.email)

  CoffeeReview.create!(
    coffee_brand: brand,
    rating: row['rating'],
    review: row['review'],
    user: random_user
  )
end

puts "Created #{CoffeeBrand.count} coffee brands"
puts "Created #{CoffeeReview.count} professional reviews"

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