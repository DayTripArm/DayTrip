class BookedTrip < ApplicationRecord
  belongs_to :logins, optional: true, :foreign_key => "traveler_id"
  belongs_to :trip, optional: true
end
