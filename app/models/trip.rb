class Trip < ApplicationRecord
  has_many :destinations_trips
  has_many :destinations, through: :destinations_trips

  mount_uploaders :images, ImageUploader
  mount_uploaders :map_image, ImageUploader
  scope :active_trips, ->  { where(:published => true) }
  #scope :top_choices, ->  { where(:is_top_choice => true) }
end
