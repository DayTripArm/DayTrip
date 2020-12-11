class TripReview < ApplicationRecord
  belongs_to :login, optional: true, foreign_key: :login_id
  belongs_to :trips, optional: true, foreign_key: :trip_id
end
