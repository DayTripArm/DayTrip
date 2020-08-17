class DriverReviewsController < ApplicationController
  def create
    begin
      new_review = DriverReview.new(review_params)
      new_review.save!
      render json: {message: "Your review has been saved."}, status: :ok
    rescue StandardError => e
      render json: e.message, status: :ok
    end
  end

  private
  def review_params
    params.require(:driver_review).permit(:traveler_id, :driver_id, :rate, :review_text)
  end
end
