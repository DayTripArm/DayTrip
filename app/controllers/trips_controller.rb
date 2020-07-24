class TripsController < ApplicationController
  def index
    trips = Trip.active_trips
    if params[:query]
      trips = trips.searched_trips(params[:query])
    end
    if params[:top_choice]
      trips = trips.filter_trips(params[:limit], params[:offset])
    end
    render json: trips, status: :ok
  end

  def trip_detail
    if params[:id]
      begin
        trip = Trip.find_by(:id => params[:id])
      rescue StandartError => e
        render json: e.messages, status: :ok
      end
    end
    render json: trip, status: :ok
  end

end