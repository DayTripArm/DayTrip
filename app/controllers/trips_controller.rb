class TripsController < ApplicationController

  def new
    @trip = Trip.new
  end

  def create
    trip = Trip.create(trip_params)
    redirect_to collection_url
  end

  def show
    @trip = Trip.find(params[:id])
  end

  private

  def trip_params
    params.require(:trip).permit(:title, :content, :is_published)
  end

end