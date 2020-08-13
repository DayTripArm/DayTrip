class TripReview < ApplicationRecord
  belongs_to :logins, optional: true
  belongs_to :trips, optional: true
end
