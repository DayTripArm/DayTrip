class Trip < ApplicationRecord
  has_many :destinations_in_trips
  has_many :destinations, through: :destinations_in_trips

  mount_uploaders :images, ImageUploader
  mount_uploaders :map_image, ImageUploader

  scope :active_trips, ->  { where(:published => true) }
  scope :searched_trips, ->(query) { select("id, title, images").where("title like ? ", "%#{query}%") }
  scope :filter_trips,->(limit,offset) { limit(limit).offset(offset) }
  scope :top_choices, ->  { where(:is_top_choice => true) }
end
