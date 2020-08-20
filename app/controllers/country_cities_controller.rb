class CountryCitiesController < ApplicationController
  def index
    cc_all = CountryCity.all
    render json: { cities: cc_all }, status: :ok
  end

end
