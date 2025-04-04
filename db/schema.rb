# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_26_013638) do
  create_table "coffee_brands", force: :cascade do |t|
    t.string "name"
    t.string "roaster"
    t.string "origin"
    t.string "roast_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coffee_reviews", force: :cascade do |t|
    t.integer "coffee_brand_id", null: false
    t.decimal "rating"
    t.text "review"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coffee_brand_id"], name: "index_coffee_reviews_on_coffee_brand_id"
    t.index ["user_id"], name: "index_coffee_reviews_on_user_id"
  end

  create_table "coffee_shops", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "country"
    t.float "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "phone"
    t.string "address"
    t.string "slug"
    t.index ["slug"], name: "index_coffee_shops_on_slug", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.text "content"
    t.integer "rating"
    t.integer "coffee_shop_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coffee_shop_id"], name: "index_reviews_on_coffee_shop_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "coffee_reviews", "coffee_brands"
  add_foreign_key "coffee_reviews", "users"
  add_foreign_key "reviews", "coffee_shops"
  add_foreign_key "reviews", "users"
end
