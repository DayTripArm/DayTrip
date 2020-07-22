class Trip < ApplicationRecord
  has_many :destinations_trips
  has_many :destinations, through: :destinations_trips

  mount_uploaders :images, ImageUploader
  mount_uploaders :map_image, ImageUploader
end
