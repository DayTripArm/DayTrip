class DestinationsTrip < ApplicationRecord
  belongs_to :destinations, :class_name => 'Destination', :foreign_key => 'destination_id'
  belongs_to :trips, :class_name => 'Trip', :foreign_key => 'trip_id'
end
