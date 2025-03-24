require 'csv'
require 'faker'
require 'httparty'

# Clear existing data in proper order to respect dependencies
Review.destroy_all
CoffeeReview.destroy_all
CoffeeShop.destroy_all
CoffeeBrand.destroy_all
User.destroy_all

# 1. First create base users
puts "Creating users..."
50.times do
  User.create!(
    username: Faker::Internet.username,
    email: Faker::Internet.email
  )
end

# 2. Import Starbucks locations
puts "Importing coffee shops..."
skipped_rows = 0
successful_rows = 0

CSV.foreach(Rails.root.join('db', 'starbucks_locations.csv'), headers: true, encoding: 'bom|utf-8') do |row|
  begin
    next unless row['City'].present? && row['Country'].present?

    latitude = row['Latitude'].to_s.gsub(/[^0-9.-]/, '').to_f
    longitude = row['Longitude'].to_s.gsub(/[^0-9.-]/, '').to_f
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

puts "Successfully imported #{successful_rows} coffee shops"
puts "Skipped #{skipped_rows} problematic rows"

# 3. Import coffee brands and professional reviews
if File.exist?(Rails.root.join('db', 'coffee_reviews.csv'))
  puts "Importing coffee brands and reviews..."
  brands_created = 0
  reviews_created = 0

  CSV.foreach(Rails.root.join('db', 'coffee_reviews.csv'), headers: true) do |row|
    begin
      brand = CoffeeBrand.create!(
        name: row['name'],
        roaster: row['roaster'],
        origin: row['origin'],
        roast_level: row['roast_level']
      )
      brands_created += 1

      CoffeeReview.create!(
        coffee_brand: brand,
        rating: row['rating'],
        review: row['review'],
        user: User.all.sample
      )
      reviews_created += 1
    rescue => e
      puts "Skipping coffee review row: #{e.message}"
    end
  end

  puts "Created #{brands_created} coffee brands"
  puts "Created #{reviews_created} professional reviews"
else
  puts "Skipping coffee reviews import - file not found"
end

# 4. Create user reviews for coffee shops
puts "Creating user reviews..."
reviews_created = 0

User.all.each do |user|
  CoffeeShop.all.sample(5).each do |shop|
    begin
      Review.create!(
        content: Faker::Restaurant.review,
        rating: rand(1..5),
        coffee_shop: shop,
        user: user
      )
      reviews_created += 1
    rescue => e
      puts "Failed to create review: #{e.message}"
    end
  end
end

puts "Created #{reviews_created} user reviews"

# Final summary
puts "\nSeeding complete!"
puts "Total records:"
puts "- Users: #{User.count}"
puts "- Coffee Shops: #{CoffeeShop.count}"
puts "- Coffee Brands: #{CoffeeBrand.count}"
puts "- Professional Reviews: #{CoffeeReview.count}"
puts "- User Reviews: #{Review.count}"