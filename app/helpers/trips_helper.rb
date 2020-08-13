include ActionView::Helpers::NumberHelper
module TripsHelper
  def self.trip_reviews_count(trip)
    trip.trip_reviews.count
  end

  def self.trip_reviews_rate(trip)
    number_with_precision(trip.trip_reviews.average(:rate), :precision => 1) || "0.0"
  end

  def self.is_favourite(trip, login_id)
    trip.saved_trips.where("saved_trips.login_id = ?", login_id).blank? ? false : true
  end

  def self.trip_destinations(trip)
    dests = []
    trip.destinations_in_trips.each do | trip_dest|
      dests << {
          stop_title: trip_dest.stops_title,
          dest_title: trip_dest.destination.title,
          dest_desc: trip_dest.destination.description,
          dest_image: trip_dest.destination.image
      }
    end
    dests
  end
end
