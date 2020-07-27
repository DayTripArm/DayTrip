class TripsController < ApplicationController
  def index
    trips = Trip.active_trips
    if params[:query]
      trips = trips.searched_trips(params[:query])
    elsif params[:top_choice]
      trips = trips.filter_trips(params[:limit], params[:offset])
    else
      trips = trips.filter_trips(params[:limit], params[:offset])
    end
    render json: trips, status: :ok
  end

  def trip_detail
    if params[:id]
      begin
        trip = Trip.active_trips.joins(:destinations_in_trips, :destinations)
                   .where(id: params[:id]).distinct().first

        render json: { trip: trip, destinations: trip.destinations}, status: :ok
      rescue StandardError => e
        render json: e.message, status: :ok
      end
    end
  end

  # Save a trips as a traveler
  # POST /save_trip
  def save_trip
    errors = []
    begin
      save_trip = SavedTrip.new({login_id: params[:login_id], trip_id: params[:trip_id]})
      save_trip.save
      render json: {message: "Your trip has been saved."}, status: :ok
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
end