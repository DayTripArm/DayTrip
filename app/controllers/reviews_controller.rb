class ReviewsController < ApplicationController
  # Create review for driver
  # GET /driver_review
  def driver_review
    begin
      if DriverReview.where({driver_id: params[:driver_id], traveler_id: params[:traveler_id], booked_trip_id: params[:booked_trip_id]}).blank?
        new_review = DriverReview.new(driver_review_params)
        new_review.save!
        render json: {message: "Your review has been saved."}, status: :ok
      else
        render json: {message: "You've alreaady reviewed driver."}, status: :ok
      end
    rescue StandardError => e
      render json: e.message, status: :ok
    end
  end

  # Create review for trip
  # GET /trip_review
  def trip_review
    begin
      if TripReview.where({login_id: params[:login_id], booked_trip_id: params[:booked_trip_id]}).blank?
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
    params.require(:review).permit(:login_id, :trip_id, :booked_trip_id, :rate, :review_text)
  end
  private
  def driver_review_params
    params.require(:review).permit(:traveler_id, :driver_id, :booked_trip_id, :rate, :review_text)
  end
end
