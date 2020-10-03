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
      drivers_list = []
      drivers = Login.joins(:profile, :driver_info, :photos)
                    .select("logins.id, logins.user_type, profiles.name AS driver_name, profiles.languages, driver_infos.car_seats, driver_infos.car_specs,
                            driver_infos.hit_the_road_tariff, driver_infos.tariff1, driver_infos.tariff1, driver_infos.tariff2,
                            driver_infos.car_mark, driver_infos.car_model")
                    .where("logins.user_type = 2").distinct

      unless params[:travelers].blank?
        drivers = drivers.where("car_seats >= ?", params[:travelers].to_i)
      end
      unless params[:date].blank?

        drivers = drivers.joins(:calendar_setting).where
                      .not("calendar_settings.unavailable_days ->> 'excluded_days' LIKE ?", "%#{params[:date]}%")
      end
      drivers = drivers.limit(params[:limit] || 10).offset(params[:offset] || 0)
      unless params[:trip_id].blank?
        trip_details = Trip.select('images, title, trip_duration, start_location').where(id: params[:trip_id])
        drivers = drivers.order("tariff1 #{params[:sort] || 'ASC'}, tariff2 #{params[:sort] || 'ASC'}")
      else
        drivers = drivers.where("AND driver_infos.hit_the_road_tariff is not null")
                      .order(hit_the_road_tariff: params[:sort] || 'ASC').distinct
      end

      drivers.each_with_index do |driver, index|
        drivers_list[index] = driver.to_json
        drivers_list[index] = JSON.parse(drivers_list[index])
        drivers_photos = driver.photos.where(file_type: [1,2])
        drivers_list[index].merge!({:profile_photos => {}, :car_photos => []})
        drivers_photos.each do |photo|
          photo.full_path = PhotosHelper::get_photo_full_path(photo.name,  Photo::FILE_TYPES.key(photo.file_type), photo[:login_id].to_s)
          drivers_list[index][:profile_photos] = photo if photo.file_type == 1
          drivers_list[index][:car_photos] << photo if photo.file_type == 2
        end
        drivers_list[index]["car_specs"] = JSON.parse(drivers_list[index]["car_specs"])
        drivers_list[index][:car_full_name] = CarHelper::format_car_model(driver[:car_mark].to_i, driver[:car_model].to_i)
      end

      render json: {trip_details: trip_details, drivers_list: drivers_list}, status: :ok
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end
end
