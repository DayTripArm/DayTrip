class DriverInfosController < ApplicationController
  def create
    driver_info = DriverInfo.new
    profile = Profile.find_by({login_id: params[:login_id]})
    driver_info.assign_attributes(driver_info_params.merge({login_id: params[:login_id]}))
    profile.assign_attributes(profile_info_params)
    if driver_info.save && profile.save
      render json: {message: "Driver information has been updated."}, status: :ok
    else
      driver_attrs = driver_info.errors.messages.keys
      profile_attrs = profile.errors.messages.keys if profile.errors.messages.blank?
      driver_errors = driver_info.errors.messages.transform_values!.with_index { |msg, ind| ["#{driver_attrs[ind].capitalize} #{msg[0]}"] }
      profile_errors = profile.errors.messages.transform_values!.with_index { |msg, ind| ["#{profile_attrs[ind].capitalize} #{msg[0]}"] } if profile.errors.messages.blank?
      render json: driver_errors + profile_errors, status: :bad_request
    end
  end

  def driver_info_params
    params.require(:driver_info).permit(:car_type, :car_mark, :car_model, :car_year, :car_color, :car_seats, :car_specs, :driver_destinations, :price_per_km)
  end

  def profile_info_params
    params.require(:profile_info).permit(:gender, :date_of_birth, :languages, :about, :work, :location)
  end
end
