class ReviewsController < ApplicationController
  # Create review for driver
  # GET /driver_review
  def driver_review
    begin
      new_review = DriverReview.new(driver_review_params)
      new_review.save!
      render json: {message: "Your review has been saved."}, status: :ok
    rescue StandardError => e
      render json: e.message, status: :ok
    end
  end

  # Create review for trip
  # GET /trip_review
  def trip_review
    begin
      if TripReview.where({trip_id: params[:trip_id], login_id: params[:login_id]}).blank?
        new_review = TripReview.new(trip_review_params)
        new_review.save!
        render json: {message: "Your review has been saved."}, status: :ok
      else
        render json: {message: "You've alreaady reviewed the trip."}, status: :ok
      end
    rescue StandardError => e
      render json: e.message, status: :ok
    end
  end

  private
  def trip_review_params
    params.require(:review).permit(:login_id, :trip_id, :rate, :review_text)
  end
  private
  def driver_review_params
    params.require(:review).permit(:traveler_id, :driver_id, :rate, :review_text)
  end
end
