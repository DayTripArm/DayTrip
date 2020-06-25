class CarBrandsController < ApplicationController
  def index
    car_brands = CarBrand.all
    render json: { brands: car_brands }, status: :ok
  end

  def get_car_models
    car_models = CarModel.where(brand_id: params[:id])
    render json: { car_models: car_models }, status: :ok
  end
end
