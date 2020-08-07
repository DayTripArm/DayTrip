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
      errors << e.message if e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  # Retrieve all driver related information
  def edit
    drivers_info_obj = {}
    driver_info = DriverInfo.where(login_id: params[:id])
    car_photos = Photo.car_photos(params[:id])
    drivers_info_obj = {
        car_details: {
            car_info: driver_info.car_details.first,
            car_photos: car_photos
        },
        more_details: driver_info.more_details.first,
        prices: driver_info.prices.first
    }
    render json: drivers_info_obj, status: :ok
  end

  # Update all driver related information
  def update
    begin
      errors = []
      unless params[:car_info].empty?
        driver_info = DriverInfo.find_by({login_id: params[:login_id]})
        driver_info.assign_attributes(params[:car_info])
        # TODO add update car photos
        #file_save = PhotosHelper::upload_and_save_photos(login, type_int, car_photos, params[:car_photos]) unless params[:car_photos].blank?
        if driver_info.save
          render json: {message: "Driver information has been updated."}, status: :ok
        else
          render json: {message: "Driver information failed to be updated."}, status: :ok
        end
      end
    rescue StandardError, ActiveRecordError => e
      puts "\n\n  e  #{e.inspect}   \n\n"
      errors << e.message if e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  def driver_info_params
    params.require(:driver_info).permit(:car_type, :car_mark, :car_model, :car_year, :car_color, :car_seats, :car_specs, :driver_destinations, :tariff1, :tariff2)
  end

  def profile_info_params
    params.require(:profile_info).permit(:gender, :date_of_birth, :languages, :about, :work, :location)
  end
end
