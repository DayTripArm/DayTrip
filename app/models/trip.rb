class Trip < ApplicationRecord
  has_many :destinations_in_trips, ->{ order(position: :asc) }, :dependent => :destroy, inverse_of: :trip
  has_many :destinations, through: :destinations_in_trips, :dependent => :destroy
  has_many :saved_trips
  has_many :logins, through: :saved_trips
  has_many :trip_reviews
  has_many :booked_trips, :dependent => :restrict_with_error

  accepts_nested_attributes_for :destinations_in_trips, :allow_destroy => true

  mount_uploaders :images, ImageUploader
  mount_uploaders :map_image, ImageUploader

  self.ignored_columns = %w(created_at updated_at)

  scope :active_trips, -> (lang) { where({:published => true, :lang => lang}) }
  scope :searched_trips, ->(query) {
        select("trips.id, trips.title, trips.images")
        .joins(:destinations)
        .where("trips.title ilike  :search OR trips.agenda ilike :search OR destinations.title ilike :search OR destinations.description ilike :search", search: "%#{query}%")
        .distinct() }
  scope :filter_trips,-> (limit,offset) { select("id, title, images, trip_duration, is_top_choice").limit(limit).offset(offset) }
  scope :top_choices, ->  { where(:is_top_choice => true) }

  validates :destinations_in_trips, presence: { :message => "must be selected." }
  validates_presence_of :lang
  validates_presence_of :title
  validates_presence_of :images
  validates_presence_of :trip_duration
  validates_presence_of :start_location
  validate :active_booking, on: :update
  def active_booking
    booking  = self.booked_trips
    if !self.published? && booking.any?{|s| Date.today.before?(Date.parse(s.trip_day.to_s))}
      self.errors[:base] << "Trip can not be unpublished. It has upcoming booked trip."
    end

  end
end
