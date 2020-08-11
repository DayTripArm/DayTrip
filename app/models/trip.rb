class Trip < ApplicationRecord
  has_many :destinations_in_trips, :dependent => :destroy
  has_many :destinations, through: :destinations_in_trips, :dependent => :destroy
  has_many :saved_trips
  has_many :logins, through: :saved_trips
  has_many :reviews

  accepts_nested_attributes_for :destinations_in_trips, :allow_destroy => true

  mount_uploaders :images, ImageUploader
  mount_uploaders :map_image, ImageUploader

  self.ignored_columns = %w(created_at updated_at)

  scope :active_trips, ->  { where(:published => true) }
  scope :searched_trips, ->(query) {
        select("trips.id, trips.title, trips.images")
        .joins(:destinations)
        .where("trips.title ilike  :search OR trips.agenda ilike :search OR destinations.title ilike :search OR destinations.description ilike :search", search: "%#{query}%")
        .distinct() }
  scope :filter_trips,-> (limit,offset) { select("id, title, images, trip_duration, is_top_choice").limit(limit).offset(offset) }
  scope :top_choices, ->  { where(:is_top_choice => true) }
end
