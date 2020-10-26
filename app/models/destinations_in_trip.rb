class DestinationsInTrip < ApplicationRecord
  belongs_to :trip, optional: true
  belongs_to :destination, optional: true
end
