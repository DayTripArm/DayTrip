class TripReview < ApplicationRecord
  belongs_to :login, optional: true, foreign_key: :login_id
  #belongs_to :trips, optional: true, foreign_key: :trip_id
  belongs_to :booked_trip, optional: true, foreign_key: :booked_trip_id
end
