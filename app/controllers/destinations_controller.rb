class DestinationsController < ApplicationController
  def index
    destinations = Destination.published.all
    render json: {destinations: destinations}, status: :ok
  end
end
