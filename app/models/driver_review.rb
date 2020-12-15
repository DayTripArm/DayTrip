class DriverReview < ApplicationRecord
  belongs_to :login, optional: true, foreign_key: :driver_id
  belongs_to :booked_trips, optional: true, foreign_key: :booked_trip_id
end
