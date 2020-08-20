class CountryCitiesController < ApplicationController
  def index
    search_cities = CountryCity.where("city ilike  :search", search: "%#{params[:city]}%").order(city: :desc)
    render json: { cities: search_cities }, status: :ok
  end

end
