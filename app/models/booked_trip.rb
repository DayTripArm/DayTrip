class BookedTrip < ApplicationRecord
  belongs_to :driver, class_name: 'Login'
  belongs_to :traveler, class_name: 'Login'
  belongs_to :driver_info, optional: true, :foreign_key => "driver_id"
  belongs_to :profile, optional: true
  belongs_to :photos, optional: true
  belongs_to :trip, optional: true, :foreign_key => "trip_id"
  has_one :driver_review, foreign_key: :booked_trip_id
  has_one :trip_review, foreign_key: :booked_trip_id

  scope :travelers_info, -> (login_id) { where(traveler_id: login_id) }
  scope :upcoming_trips, -> (driver_id) { where("driver_id =? AND trip_day >=?", driver_id, Date.current) }
  scope :completed_trips, -> (driver_id) { where("driver_id =? AND trip_day <?", driver_id, Date.current) }
  scope :popular_trips, -> (driver_id) { where({driver_id: driver_id}).group(:trip_id).order('count(id) DESC').select("count(*) as booked_count, trip_id").first }
  scope :current_month_bookings, -> () { where("trip_day > ? AND trip_day < ?", Time.now.beginning_of_month, Time.now.end_of_month) }
end
