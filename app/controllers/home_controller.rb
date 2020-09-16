class HomeController < ApplicationController
  def heroes
    heroes = Hero.where(published: true).first
    render json: heroes, status: :ok
  end

  def hit_the_road
    hit_the_road = HitTheRoad.where(published: true).first
    render json: hit_the_road, status: :ok
  end

  def search_drivers
    errors = []
    begin
      drivers_list = {}
      drivers = Login.joins(:profile, :driver_info, :photos)
                    .select("logins.id, profiles.name AS driver_name, driver_infos.car_specs")
                    .where("logins.user_type = 2").distinct

      unless params[:travelers].blank?
        drivers.where("car_seats >= ?", params[:travelers])
      end
      unless params[:date].blank?
        drivers.joins(:calendar_settings).where.not("unavailable_days", params[:date])
      end

      drivers.each_with_index do |driver, index|
        drivers_list[index] = driver.to_json
        drivers_photos = driver.photos.where(file_type: [1,2])
        drivers_photos.each do |photo|
          photo.full_path = PhotosHelper::get_photo_full_path(photo.name,  Photo::FILE_TYPES.key(photo.file_type), photo[:login_id].to_s)
        end
        drivers_list[index] = JSON.parse(drivers_list[index])
        drivers_list[index][:drivers_photos] = drivers_photos
      end
      unless params[:trip_id].blank?
        trip_details = Trip.select('iamges, title, trip_duration, start_location').where(id: params[:trip_id])
      end

      render json: {trip_details: trip_details, drivers: drivers_list}, status: :ok
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end
end
