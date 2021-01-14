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
        profile.status = Profile::STATUS_REG
        driver_info.save!
        profile.save!
        Photo::FILE_TYPES.each do |type, type_int|
            file_save = PhotosHelper::upload_and_save_photos(login, type_int, type, params[type]) unless params[type].blank?
        end
        login.update_attribute(:is_prereg, false) if params[:prereg_finish]
        notify_admins("prereg")
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
      file_save = nil
      # TODO add update car photos
      Photo::FILE_TYPES.each do |type, type_int|
        next if params[type].blank?
        file_save = PhotosHelper::upload_and_save_photos(Login.where({id: params[:login_id]}).first, type_int, type, params[type]) unless params[type].blank?
      end

      unless params[:car_info].blank?
        params[:car_info] = JSON.parse(params[:car_info])
        driver_info = DriverInfo.find_by({login_id: params[:login_id]})
        driver_info.update_attributes(car_info_params)
        if driver_info.save
          if [:car_type, :car_mark, :car_model, :car_color].any? {|k| car_info_params.key?(k)}
            notify_admins("car_details")
          end
          render json: {message: "Driver information has been updated."}, status: :ok
        else
          render json: {message: "Driver information failed to be updated."}, status: :ok
        end
      end
      if file_save
        if [:car_photos,:gov_photos,:license_photos,:reg_card_photos].any? {|k| params.key?(k)}
          notify_admins("car_details")
        end
        render json: {message: "Car photo has been added."}, status: :ok
      end
    rescue StandardError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  # Remove driver one photo
  def delete_photo
    begin
      errors = []
      unless params[:photo].blank?
        PhotosHelper::remove_photos(params[:photo])
        notify_admins("car_details")
        render json: {message: "Photo has been deleted."}, status: :ok
      end
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  def driver_progress
    errors = []
    begin
      driver_reviews = DriverReview.where({driver_id: params[:id]})
      current_month_earnings = BookedTrip.where({driver_id: params[:id]}).current_month_bookings.sum(:price)
      overall_rating = driver_reviews.blank? ? 0: TripsHelper::trip_reviews_rate(driver_reviews)
      bookings = BookedTrip.where({driver_id: params[:id]}).count()
      completed_trips = BookedTrip.completed_trips(params[:id]).last_month_bookings.count()
      popular_trips_count = BookedTrip.where({driver_id: params[:id]}).group(:trip_id).count(:id)
      upcoming_trips = BookedTrip.upcoming_trips(params[:id]).count()
      render json: {
          current_month_earnings: current_month_earnings || 0,
          overall_rating: overall_rating,
          bookings: bookings,
          completed_trips: completed_trips,
          popular_trips: popular_trips_count.count,
          upcoming_trips: upcoming_trips,
      }, status: :ok
    rescue StandardError=> e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  def view_driver_progress
    errors = []
    progress_details = {}
    begin
      member_since = Login.where(id: params[:id]).first.created_at.to_date
      case params[:section_type].to_i
        when 1
          progress_details[:monthly_earnings] = BookedTrip.select("date_trunc('month', series_date) as full_date,
                                                          TO_CHAR(date_trunc('month', series_date), 'Month YYYY') as month,
                                                          sum(
                                                            COALESCE(booked_trips.price, 0)
                                                          ) AS mountly_result")
                                                          .from("generate_series(
                                                             '#{member_since}'::timestamp,
                                                             '#{Date.current}'::timestamp,
                                                             '1 day'
                                                           ) AS series_date")
                                                          .joins("LEFT JOIN booked_trips ON booked_trips.trip_day::date = series_date AND driver_id = #{params[:id]}")
                                                          .group("full_date, month")
                                                          .order("full_date desc")
      when 2
          driver_reviews = DriverReview.select("driver_reviews.*,
                                               date_trunc('month', series_date) as full_date,
                                               TO_CHAR(date_trunc('month', series_date), 'Month YYYY') as month")
                                       .from("generate_series(
                                               '#{member_since}'::timestamp,
                                               '#{Date.current}'::timestamp,
                                               '1 day'
                                             ) AS series_date")
                                       .joins("RIGHT JOIN driver_reviews ON driver_reviews.created_at::date = series_date AND driver_id = #{params[:id]}")
                                       .group("full_date, month, driver_reviews.id")
                                       .order("full_date desc")
          progress_details[:overall_rating] = {
              rate: driver_reviews.blank? ? "0.0": driver_reviews.sum { |x| x["rate"] }.to_f / driver_reviews.size,
              reviews: driver_reviews_list(driver_reviews)
          }
      when 4
          progress_details[:completed_trips] = BookedTrip
                                                   .select("date_trunc('month', series_date) as full_date,
                                                          TO_CHAR(date_trunc('month', series_date), 'Month YYYY') as month,
                                                          count(
                                                            COALESCE(booked_trips.id, NULL)
                                                          ) AS mountly_result")
                                                   .from("generate_series(
                                                     '#{member_since}'::timestamp,
                                                     '#{Date.current}'::timestamp,
                                                     '1 day'
                                                   ) AS series_date")
                                                   .joins("LEFT JOIN booked_trips ON booked_trips.trip_day::date = series_date
                                                          AND driver_id = #{params[:id]} AND trip_day < '#{Date.current}'")
                                                   .group("full_date, month")
                                                   .order("full_date desc")
     when 5
          popular_trips = BookedTrip.popular_trips(params[:id])
          if popular_trips.blank?
            progress_details[:popular_trips] = []
          else
            progress_details[:popular_trips] = []
            popular_trips.each do |popular_trip|
              progress_details[:popular_trips] << {
                  popularity_score: popular_trip.booked_count,
                  trip_details: popular_trip.trip.blank? ? {
                      id: HitTheRoad.active_hit_the_road.blank? ? nil: HitTheRoad.active_hit_the_road.id,
                      title: 'Hit the Road',
                      image: HitTheRoad.active_hit_the_road.blank? ? nil: HitTheRoad.active_hit_the_road.image.url,
                      trip_review: {
                          count: 0,
                          rate:  nil
                      }
                  } : {
                      id: popular_trip.trip.id,
                      title: popular_trip.trip.title,
                      image: popular_trip.trip.images.first.url,
                      trip_review: {
                          count: TripsHelper::trip_reviews_count(popular_trip.trip.trip_reviews),
                          rate:  TripsHelper::trip_reviews_rate(popular_trip.trip.trip_reviews)
                      }
                  }

              }
            end
          end
        when 6
          progress_details[:upcoming_trips] = BookedTrip
                                            .select("date_trunc('month', series_date) as full_date,
                                                    TO_CHAR(date_trunc('month', series_date), 'Month YYYY') as month,
                                                    count(
                                                      COALESCE(booked_trips.id, NULL)
                                                    ) AS mountly_result")
                                            .from("generate_series(
                                               '#{Date.current}'::timestamp,
                                               '#{Date.current + 12.month}'::timestamp,
                                               '1 day'
                                             ) AS series_date")
                                            .joins("LEFT JOIN booked_trips ON booked_trips.trip_day::date = series_date
                                                   AND driver_id = #{params[:id]} AND trip_day >= '#{Date.current}'")
                                            .group("full_date, month")
                                            .order("full_date asc")
      end

      render json: progress_details, status: :ok
    rescue StandardError=> e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  # Permit request params
  def driver_info_params
    params.require(:driver_info).permit(:car_type, :car_mark, :car_model, :car_year, :car_color, :car_seats, :car_specs, :driver_destinations, :tariff1, :tariff2, :hit_the_road_tariff)
  end

  def profile_info_params
    params.require(:profile_info).permit(:gender, :date_of_birth, :languages, :about, :work, :location)
  end

  def car_info_params
    params.require(:car_info).permit(:car_type, :car_mark, :car_model, :car_year, :car_color, :car_seats, :car_specs, :driver_destinations, :tariff1, :tariff2, :hit_the_road_tariff)
  end

  # Private methods
  private
  def notify_admins type
    case type
      when "car_details"
        UserNotifierMailer.notify_admins_car_details(params[:id]).deliver_later(wait: 30.seconds)
        UserNotifierMailer.notify_drivers_suspend(params[:login_id]).deliver_later(wait: 30.seconds)
      when "prereg"
        UserNotifierMailer.notify_admins_prereg(params[:login_id]).deliver_later(wait: 30.seconds)
        UserNotifierMailer.notify_drivers_prereg(params[:login_id]).deliver_later(wait: 30.seconds)
    end
  end

  def set_user_status profile
    profile = Profile.find_by({login_id: params[:login_id]}) if profile.nil?
    profile.update({status: Profile::STATUS_SUSPENDED})
  end

  def driver_reviews_list(reviews)
    driver_reviews = {}
    reviews.each do |review|
      driver_reviews["#{review.month}"] = [] if driver_reviews["#{review.month}"].blank?
      profile_photo = review.login.photos.where(file_type: 1).first
      unless profile_photo.blank?
        reviewer_img = PhotosHelper::get_photo_full_path(profile_photo.name,  Photo::FILE_TYPES.key(profile_photo.file_type), (review.has_attribute?(:traveler_id)? review.traveler_id: review.login_id).to_s)
        reviewer_img = File.join("/uploads","profile_photos","blank-profile.png") unless File.exists?(reviewer_img)
      else
        reviewer_img = File.join("/uploads","profile_photos","blank-profile.png")
      end
      driver_reviews["#{review.month}"] << {
          review_text: review.review_text,
          reviewer_name: review.login.profile.name,
          rate: number_with_precision(review.rate, :precision => 1),
          reviewer_img: reviewer_img,
          created_at: review.created_at
      }
    end
    driver_reviews
  end
end
