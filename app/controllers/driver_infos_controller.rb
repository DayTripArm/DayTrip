class DriverInfosController < ApplicationController
  # Add all driver related information
  def create
    errors = []
    begin
      params[:driver_info] = JSON.parse(params[:driver_info])
      params[:profile_info] = JSON.parse(params[:profile_info])
      unless params[:driver_info].blank? && params[:profile_info].blank?
        login = Login.where(id: params[:login_id]).first

        driver_info = DriverInfo.new
        profile = Profile.find_by(login_id: params[:login_id])
        driver_info.assign_attributes(driver_info_params.merge({login_id: params[:login_id]}))
        profile.assign_attributes(profile_info_params)
        driver_info.save!
        profile.save!
        Photo::FILE_TYPES.each do |type, type_int|
            file_save = PhotosHelper::upload_and_save_photos(login, type_int, type, params[type]) unless params[type].blank?
        end
        login.update_attribute(:is_prereg, false) if params[:prereg_finish]

        render json: {message: "Driver information has been saved."}, status: :ok
      else
        render json: {message: "Please fill in required fields"}, status: :ok
      end
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  # Retrieve all driver related information
  def edit
    begin
      drivers_info_obj = {}
      errors = []
      driver_info = DriverInfo.where(login_id: params[:id])
      unless driver_info.blank?
        drivers_info_obj = {
            car_details: {
                car_info: driver_info.car_details.first
            },
            more_details: driver_info.more_details.first,
            prices: driver_info.prices.first
        }

        Photo::FILE_TYPES.each do |type, type_int|
          next if type_int == 1
          driver_photos = Photo.where({login_id: params[:id], file_type: type_int})
          driver_photos.each do |photo|
            photo.full_path = PhotosHelper::get_photo_full_path(photo.name, type, params[:id])
          end
          drivers_info_obj[:car_details][type] = driver_photos
        end
      end
      render json: drivers_info_obj, status: :ok
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  # Update all driver related information
  def update
    begin
      errors = []
      # TODO add update car photos
      #file_save = PhotosHelper::upload_and_save_photos(login, type_int, "car_photos", params[:car_photos]) unless params[:car_photos].blank?
      Photo::FILE_TYPES.each do |type, type_int|
        next if params[type].blank?
        file_save = PhotosHelper::upload_and_save_photos(Login.where({id: params[:login_id]}), type_int, type, params[type])
      end

      unless params[:car_info].blank?
        driver_info = DriverInfo.find_by({login_id: params[:login_id]})
        driver_info.update_attributes(car_info_params)
        if driver_info.save
          render json: {message: "Driver information has been updated."}, status: :ok
        else
          render json: {message: "Driver information failed to be updated."}, status: :ok
        end
      end
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  # Remove driver one photo
  def delete_photo
    begin
      errors = []
      unless params[:id].blank?
        PhotosHelper::remove_photos(Login.where({id: params[:id]}).first, params[:photo])
        render json: {message: "Photo has been deleted."}, status: :ok
      end
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  def driver_info_params
    params.require(:driver_info).permit(:car_type, :car_mark, :car_model, :car_year, :car_color, :car_seats, :car_specs, :driver_destinations, :tariff1, :tariff2)
  end

  def profile_info_params
    params.require(:profile_info).permit(:gender, :date_of_birth, :languages, :about, :work, :location)
  end

  def car_info_params
    params.require(:car_info).permit(:car_type, :car_mark, :car_model, :car_year, :car_color, :car_seats, :car_specs, :driver_destinations, :tariff1, :tariff2)
  end
end
