class DestinationsController < ApplicationController
  def index
    destinations = Destination.published.all
    destinations = destinations.where(lang: params[:lang]).all unless params[:lang].blank?
    render json: {destinations: destinations}, status: :ok
  end
end
