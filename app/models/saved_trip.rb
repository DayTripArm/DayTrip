class SavedTrip < ApplicationRecord
  belongs_to :login
  belongs_to :trip
end
