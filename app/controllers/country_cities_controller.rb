class CountryCitiesController < ApplicationController
  def index
    cities = CountryCity.all.order(city: :asc)
    cities = CountryCity.where("city ilike  :search", search: "%#{params[:city]}%").order(city: :asc) unless params[:city].blank?
    render json: { cities: cities }, status: :ok
  end

end
