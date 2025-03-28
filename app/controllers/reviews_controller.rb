class ReviewsController < ApplicationController
  def create
    @coffee_shop = CoffeeShop.friendly.find(params[:coffee_shop_id])
    @review = @coffee_shop.reviews.new(review_params)

    # Create or find user based on submitted username
    if params[:review][:username].present?
      user = User.find_or_create_by(username: params[:review][:username])
      @review.user = user
    end

    if @review.save
      redirect_to @coffee_shop, notice: 'Review submitted successfully!'
    else
      @nearby_shops = @coffee_shop.nearby_shops || []
      render 'coffee_shops/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end