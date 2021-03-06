class HomeController < ApplicationController
  def heroes
    heroes = Hero.where({published: true, lang: params[:lang]}).first
    render json: heroes, status: :ok
  end

  def hit_the_road
    hit_the_road = HitTheRoad.active_hit_the_road(params[:lang])
    render json: hit_the_road, status: :ok
  end

  def search_drivers
    errors = []
    begin
      drivers_list = []
      trip_details = {}
      drivers = Login.joins(:profile, :driver_info, :photos)
                    .select("logins.id, logins.user_type, profiles.name AS driver_name, profiles.languages, driver_infos.car_seats, driver_infos.car_specs,
                            driver_infos.hit_the_road_tariff, driver_infos.tariff1, driver_infos.tariff1, driver_infos.tariff2,
                            driver_infos.car_mark, driver_infos.car_model")
                    .where("logins.user_type = 2 and profiles.status = 3").distinct

      unless params[:travelers].blank?
        drivers = drivers.where("car_seats >= ?", params[:travelers].to_i)
      end
      unless params[:date].blank?

        drivers = drivers.joins(:calendar_setting)
                      .where("calendar_settings.available_days ->> 'included_days' LIKE ?", "%#{params[:date]}%")
      end
      params[:price_range] = params[:price_range].split(',')
      unless params[:trip_id].to_i.zero?
        trip = Trip.select('id, images, title, trip_duration, start_location').where(id: params[:trip_id]).first
        min = params[:price_range].blank? ? 10: params[:price_range][0].to_i
        max = params[:price_range].blank? ? 1000: params[:price_range][1].to_i
        drivers = drivers.where("(tariff1 >= :min and tariff1 <= :max) or (tariff2 >= :min and tariff2 <= :max)",
                                min: min, max: max)
        trip_details = JSON.parse(trip.to_json)
        trip_details[:trip_review] = {
            count: TripsHelper::trip_reviews_count(trip.trip_reviews),
            rate:  TripsHelper::trip_reviews_rate(trip.trip_reviews)
        }
      else
        trip_details = HitTheRoad.active_hit_the_road
        drivers = drivers.where("driver_infos.hit_the_road_tariff IS NOT null AND hit_the_road_tariff >= ? AND hit_the_road_tariff <= ?",
                                params[:price_range].blank? ? 25000: params[:price_range][0].to_i,
                                params[:price_range].blank? ? 85000: params[:price_range][1].to_i).distinct
      end
      drivers = drivers.joins("INNER JOIN booked_trips on booked_trips.driver_id = logins.id").where("? NOT IN (SELECT trip_day FROM booked_trips)", params[:date].to_date)
      totalCount = drivers.size
      drivers = drivers.limit(params[:limit] || 5).offset(params[:offset] || 0)

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
        drivers_list[index][:review] = {
            count: TripsHelper::trip_reviews_count(driver.driver_reviews),
            rate:  TripsHelper::trip_reviews_rate(driver.driver_reviews)
        }
      end

      render json: {trip_details: trip_details, drivers_list: drivers_list, driversTotalCount: totalCount}, status: :ok
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  def price_list
    errors = []
    begin
      group_by = "hit_the_road_tariff"
      select = "hit_the_road_tariff as price1, count(hit_the_road_tariff) as price_count1"
      group_by = "price1"
      select = "tariff1 as price1, tariff2 as price2, count(tariff1) as price_count1, count(tariff2) as price_count2" if params[:is_trip] === 'true'
      group_by = "tariff1, tariff2 " if params[:is_trip] === 'true'
      prices_list = DriverInfo.select(select).group(group_by)
      render json:  get_price_list_obj(prices_list), status: :ok
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  def get_price_list_obj list
    prices_count = {}
    list.each do |item|
      prices_count[item.price1] = item.price_count1 unless item.price1.blank?
      if item.respond_to?(:price2)
        if prices_count[item.price2].blank?
          prices_count[item.price2] = item.price_count2
        else
          prices_count[item.price2] += item.price_count2
        end
      end
    end
    prices_count
  end
end
