module CarHelper
  def self.format_car_model(car_mark, car_model)
    CarBrand.where(id: car_mark).first.brand_name + "  " + CarModel.where(id: car_model).first.car_model_name
  end
end
