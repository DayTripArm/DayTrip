class TripsController < ApplicationController
  def index
    trips_arr = Array.new()
    trips = Trip.active_trips
    tripsTotalCount = trips.size
    if params[:query]
      trips = trips.searched_trips(params[:query])
      trips_arr = trips
      render json: trips_arr, status: :ok
    else
      trips = trips.filter_trips(params[:limit], params[:offset])
      trips = trips.top_choices if params[:is_top_choice] === 'true'
      trips = trips.limit(params[:limit] || 12).offset(params[:offset] || 0)
      trips.each_with_index do |trip, index|
        trips_arr[index] = {
            trip: trip,
            is_saved: TripsHelper::is_favourite(trip, params[:login_id]),
            review_stats: {
                count: TripsHelper::trip_reviews_count(trip.trip_reviews),
                rate:  TripsHelper::trip_reviews_rate(trip.trip_reviews)
            }
        }
      end
      render json: {tripsList: trips_arr, tripsTotalCount: tripsTotalCount}, status: :ok
    end
  end

  def trip_individual
    if params[:id]
      begin
        trip = Trip.active_trips.joins(:destinations_in_trips, :destinations)
                   .where(id: params[:id]).first
        render json: {
            trip: trip,
            destinations: TripsHelper::trip_destinations(trip),
            reviews: TripsHelper::trip_reviews(trip.trip_reviews),
            is_saved: TripsHelper::is_favourite(trip, params[:login_id]),
            review_stats: {
                count: TripsHelper::trip_reviews_count(trip.trip_reviews),
                rate:  TripsHelper::trip_reviews_rate(trip.trip_reviews)
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
      if !params[:login_id].blank? && !params[:trip_id].blank? && params[:login_id]>0 && params[:trip_id]>0
          if params[:is_save]
            save_trip = SavedTrip.new({login_id: params[:login_id], trip_id: params[:trip_id]})
            save_trip.save
            render json: {message: "Trip saved."}, status: :ok
          else
            saved_trip = SavedTrip.where({login_id: params[:login_id], trip_id: params[:trip_id]}).delete_all
            render json: {message: "Trip unsaved."}, status: :ok
          end
      else
        render json: {message: "Somthing went wrong. Can't save the trip."}, status: :ok
      end
    rescue StandardError, ActiveRecordError => e
      errors << e.message if e.message.blank?
      render json: errors, status: :ok
    end
  end

  # Retrive all trips marked as favourite/saved
  # GET /saved_trips
  def get_saved_trips
    begin
      save_trip_obj = []
      saved_trips = Trip.active_trips.joins(:saved_trips).where("saved_trips.login_id = ?", params[:login_id])
      saved_trips.each_with_index do |trip, index|
        save_trip_obj[index] = JSON.parse(trip.to_json)
        save_trip_obj[index][:review_stats] = {
            count: TripsHelper::trip_reviews_count(trip.trip_reviews),
            rate:  TripsHelper::trip_reviews_rate(trip.trip_reviews)
        }
      end
      render json: save_trip_obj, status: :ok
    rescue StandardError, ActiveRecordError => e
      render json: e.message, status: :ok
    end
  end
end