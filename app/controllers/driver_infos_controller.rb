class DriverInfosController < ApplicationController
  def create
    driver_info = DriverInfo.new(driver_info_params)
    if driver_info.save
      render json: {message: "Driver information has been updated."}, status: :ok
    else
      attrs = driver_info.errors.messages.keys
      errors = driver_info.errors.messages.transform_values!.with_index { |msg, ind| ["#{attrs[ind].capitalize} #{msg[0]}"] }
      render json: driver_info.errors.messages, status: :bad_request
    end
  end

  def driver_info_params
    params.require(:driver_info).permit( :logins_id, :car_type, :car_mark, :car_model, :car_year, :car_color, :car_seats, :car_specs)
  end
end
