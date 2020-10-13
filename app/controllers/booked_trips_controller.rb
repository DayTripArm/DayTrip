class BookedTripsController < ApplicationController
  def index
    errors = []
    begin
      params[:utype] = params[:utype].to_i
      if params[:utype] == 2
        overview_bookings = []
        calendar_data = []
        booked_trips_list = BookedTrip.select('booked_trips.id, driver_id, traveler_id, trip_id, trip_day, travelers_count')
                                .where(driver_id: params[:user_id])
        overview_bookings = JSON.parse(booked_trips_list.to_json)

        booked_trips_list.each_with_index do |booked_trip, index|
          btrip = booked_trip.traveler
          traveler_photo = btrip.photos.blank? ? [] : btrip.photos.get_by_file_type(1).first
          calendar_data[index] = JSON.parse(booked_trip.to_json)
          calendar_data[index][:traveler_photo] = PhotosHelper::get_photo_full_path(traveler_photo.name,  Photo::FILE_TYPES.key(traveler_photo.file_type), traveler_photo[:login_id].to_s) unless traveler_photo.blank?

          overview_bookings[index][:trip] = { trip_image: HitTheRoad.active_hit_the_road.blank? ? "": HitTheRoad.active_hit_the_road.image.url, title: 'Hit the Road'}
          unless booked_trip.trip.nil?
            overview_bookings[index][:trip] = { trip_image: booked_trip.trip.images.first.url, title: booked_trip.trip.title}
          end
        end
        render json: {calendar_info: calendar_data, overview_trips: overview_bookings}, status: :ok
      elsif params[:utype] == 1
        travelers_trips = []
        booked_trips_list = BookedTrip.select('booked_trips.id, driver_id, traveler_id, trip_id, trip_day, travelers_count')
                                .where(traveler_id: params[:user_id])
        travelers_trips = JSON.parse(booked_trips_list.to_json)

        booked_trips_list.each_with_index do |booked_trip, index|
          travelers_trips[index][:trip] = { trip_image: HitTheRoad.active_hit_the_road.blank? ? "": HitTheRoad.active_hit_the_road.image.url, title: 'Hit the Road'}
          unless booked_trip.trip.nil?
            travelers_trips[index][:trip] = { trip_image: booked_trip.trip.images.first.url, title: booked_trip.trip.title}
          end
        end
        render json: {travelers_trips: travelers_trips}, status: :ok
      else
        render json: {}, status: :ok
      end
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  def create
    errors = []
    begin
      booked_trip = BookedTrip.where({driver_id: params[:user_id], traveler_id: params[:traveler_id], trip_day: params[:day]})
      if booked_trip.blank?
        new_booked_trip = BookedTrip.new(booked_trips_params)
        new_booked_trip.save
        render json: {message: "Your trip has booked succesfully"}, status: :ok
      else
        render json: {message: "You've already booked trip for #{params[:day]}."}, status: :ok
      end
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  # TODO: Provide API for booked trip slider
  def booked_trip_details
    errors = []
    begin
      booked_trip_details = {}
      booked_trip = BookedTrip.where({id: params[:id]}).first
      unless booked_trip.blank?
        booked_trip_details[:trip_tour] = booked_trip.trip.blank? ? {
            id: HitTheRoad.active_hit_the_road.blank? ? nil: HitTheRoad.active_hit_the_road.id,
            title: 'Hit the Road',
            image: HitTheRoad.active_hit_the_road.blank? ? "": HitTheRoad.active_hit_the_road.image.url
        } : {
            id: booked_trip.trip.id,
            title: booked_trip.trip.title,
            image: booked_trip.trip.images.first.url
        }
        booked_trip_details[:trip_info] = {
                                            trip_day: booked_trip.trip_day,
                                            travelers_count: booked_trip.travelers_count,
                                            trip_duration: booked_trip.trip.blank? ? 12 : booked_trip.trip.trip_duration
                                          }
        booked_trip_details[:pickup_info] = {
                                              pickup_time: booked_trip.pickup_time.strftime("%I:%M"),
                                              pickup_location: booked_trip.pickup_location,
                                              notes: booked_trip.notes
                                            }
        traveler_photo = booked_trip.traveler.blank? ? [] : booked_trip.traveler.photos.get_by_file_type(1).first
        profile_photo = PhotosHelper::get_photo_full_path(traveler_photo.name, Photo::FILE_TYPES.key(traveler_photo.file_type), traveler_photo[:login_id].to_s) unless traveler_photo.blank?

        traveler_info = {
            user_name: booked_trip.traveler.profile.name,
            profile_photo: profile_photo || "",
            location: booked_trip.traveler.profile.location,
            languages: booked_trip.traveler.profile.languages,
            phone: booked_trip.traveler.profile.phone
        }
        # TODO Add drivers info for travelers booked trip details
=begin
        traveler_info = {
                          user_name: booked_trip.driver.profile.name,
                          location: booked_trip.driver.profile.location,
                          languages: booked_trip.driver.profile.languages,
                          phone: booked_trip.driver.profile.phone
                        }
=end
        booked_trip_details[:traveler] = traveler_info
        booked_trip_details[:price] = booked_trip.price

        render json: booked_trip_details, status: :ok
      else
        render json: {message: "Can't find this booked trip."}, status: :ok
      end
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  private
  def booked_trips_params
    params.except(:booked_trip).permit(:driver_id, :traveler_id, :trip_id, :trip_day, :travelers_count, :pickup_location, :pickup_time, :price, :notes)
  end
end
