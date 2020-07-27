class DestinationsInTrip < ApplicationRecord
  belongs_to :trip
  belongs_to :destination
end
