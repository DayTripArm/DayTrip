class BookedTripsController < ApplicationController
  def index
    errors = []
    begin
      overview_bookings = []
      calendar_data = []
      booked_trips_list = BookedTrip.select('booked_trips.id, driver_id, traveler_id, trip_id, trip_day').joins(:login)
                              .where(driver_id: params[:user_id])
      overview_bookings = JSON.parse(booked_trips_list.to_json)

      booked_trips_list.each_with_index do |booked_trip, index|
        btrip = booked_trips_list.joins(:login).where(traveler_id: booked_trip.traveler_id).first
        traveler_photos = btrip.photos.blank? ? [] : btrip.photos.get_by_file_type(1)
        calendar_data[index] = JSON.parse(booked_trip.to_json)
        traveler_photos.each do |photo|
          photo.full_path = PhotosHelper::get_photo_full_path(photo.name,  Photo::FILE_TYPES.key(photo.file_type), photo[:login_id].to_s)
          calendar_data[index][:traveler_photos] = photo
        end
        calendar_data[index][:trip] = { trip_image: '', title: ''}
        unless booked_trip.trip.nil?
          calendar_data[index][:trip] = { trip_image: booked_trip.trip.images.first, title: booked_trip.trip.title}
        end
      end
      render json: {calendar_info: calendar_data, overview_trips: overview_bookings}, status: :ok
    rescue StandardError, ActiveRecordError => e
      errors << e.message unless e.message.blank?
      render json: errors, status: :internal_server_error
    end
  end

  def create
    begin
      booked_trip = BookedTrip.where({driver_id: params[:user_id], traveler_id: params[:traveler_id], trip_day: params[:day]})
      unless booked_trip.blank?
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

  private
  def booked_trips_params
    params.permit(:driver_id, :traveler_id, :trip_id, :trip_day, :travelers_count, :pickup_location, :pickup_time, :price, :notes)
  end
end
