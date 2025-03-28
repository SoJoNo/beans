# app/controllers/coffee_reviews_controller.rb
class CoffeeReviewsController < ApplicationController
  def create
    @coffee_brand = CoffeeBrand.find(params[:coffee_brand_id])
    @coffee_review = @coffee_brand.coffee_reviews.new(coffee_review_params)

    if params[:coffee_review][:username].present?
      user = User.find_or_create_by(username: params[:coffee_review][:username]) do |u|
      @coffee_review.user = user
    end

    if @coffee_review.save
      redirect_to @coffee_brand, notice: 'Review submitted successfully!'
    else
      render 'coffee_brands/show'
    end
  end

  private

  def coffee_review_params
    params.require(:coffee_review).permit(:review, :rating)
  end
end