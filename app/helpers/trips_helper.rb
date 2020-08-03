module TripsHelper
  def self.trip_reviews_count(trip)
    trip.reviews.count
  end

  def self.trip_reviews_rate(trip)
    trip.reviews.average(:rate) || "0.0"
  end

  def self.is_favourite(trip)
    trip.saved_trips.blank? ? false : true
  end
end
