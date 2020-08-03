class TripsController < ApplicationController
  def index
    trips_arr = Array.new()
    trips = Trip.active_trips
    if params[:query]
      trips = trips.searched_trips(params[:query])
      trips_arr = trips
    else
      trips = trips.filter_trips(params[:limit], params[:offset])
      trips = trips.top_choices if params[:is_top_choice] === 'true'
      trips.each_with_index do |trip, index|
        trips_arr[index] = {
            trip: trip,
            is_saved: TripsHelper::is_favourite(trip),
            review_stats: {
                count: TripsHelper::trip_reviews_count(trip),
                rate:  TripsHelper::trip_reviews_rate(trip)
            }
        }
      end
    end
    render json: trips_arr, status: :ok
  end

  def trip_detail
    if params[:id]
      begin
        trip = Trip.active_trips.joins(:destinations_in_trips, :destinations)
                   .where(id: params[:id]).first
        render json: {
            trip: trip,
            destinations: trip.destinations,
            reviews: trip.reviews,
            is_saved: TripsHelper::is_favourite(trip),
            review_stats: {
                count: TripsHelper::trip_reviews_count(trip),
                rate:  TripsHelper::trip_reviews_rate(trip)
            }}, status: :ok
      rescue StandardError => e
        render json: e.message, status: :ok
      end
    end
  end

  # Save a trips as a traveler
  # POST /save_trip
  def save_unsave_trip
    errors = []
    begin
      if params[:is_save]
        save_trip = SavedTrip.new({login_id: params[:login_id], trip_id: params[:trip_id]})
        save_trip.save
        render json: {message: "Trip saved."}, status: :ok
      else
        saved_trip = SavedTrip.where({login_id: params[:login_id], trip_id: params[:trip_id]}).delete_all
        render json: {message: "Trip unsaved."}, status: :ok
      end
    rescue StandardError, ActiveRecordError => e
      errors << e.message if e.message.blank?
      render json: errors, status: :ok
    end
  end

  def get_saved_trips
    begin
      saved_trips = Trip.joins(:saved_trips).where("saved_trips.login_id = ?", params[:login_id])
      render json: saved_trips, status: :ok
    rescue StandardError, ActiveRecordError => e
      render json: e.message, status: :ok
    end
  end

  def add_review
    begin
       trip = Trip.find_by(params[:id])
       new_review = trip.reviews.new(review_params)
       new_review.save!
       render json: {message: "Your review has been saved."}, status: :ok
    rescue StandardError => e
       render json: e.message, status: :ok
    end
  end

  private
  def review_params
    params.except(:trip).require(:review).permit(:login_id, :trip_id, :rate, :review_text)
  end
end