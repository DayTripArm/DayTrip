class BookedTrip < ApplicationRecord
  belongs_to :driver, class_name: 'Login'
  belongs_to :traveler, class_name: 'Login'
  belongs_to :driver_info, optional: true, :foreign_key => "driver_id"
  belongs_to :profile, optional: true
  belongs_to :photos, optional: true
  belongs_to :trip, optional: true, :foreign_key => "trip_id"

  scope :travelers_info, -> (login_id) { where(traveler_id: login_id) }
end
