class DriverInfosController < ApplicationController
  # Add all driver related information
  def create
    driver_info = DriverInfo.new
    profile = Profile.find_by({login_id: params[:login_id]})
    driver_info.assign_attributes(driver_info_params.merge({login_id: params[:login_id]}))
    profile.assign_attributes(profile_info_params)
    if driver_info.save && profile.save
      render json: {message: "Driver information has been saved."}, status: :ok
    else
      driver_attrs = driver_info.errors.messages.keys
      profile_attrs = profile.errors.messages.keys if profile.errors.messages.blank?
      driver_errors = driver_info.errors.messages.transform_values!.with_index { |msg, ind| ["#{driver_attrs[ind].capitalize} #{msg[0]}"] }
      profile_errors = profile.errors.messages.transform_values!.with_index { |msg, ind| ["#{profile_attrs[ind].capitalize} #{msg[0]}"] } if profile.errors.messages.blank?
      render json: driver_errors + profile_errors, status: :bad_request
    end
  end

  # Retrieve all driver related information
  def edit
    profile = Profile.where({login_id: params[:id]}).first
    driver_info = DriverInfo.where({login_id: params[:id]}).first
    drivers_info_obj = {
        profile_info: profile,
        driver_info: driver_info
    }
    render json: drivers_info_obj, status: :ok
  end

  # Update all driver related information
  def update
    driver_info = DriverInfo.find_by({login_id: params[:login_id]})
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
