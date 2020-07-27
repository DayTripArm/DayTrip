class Destination < ApplicationRecord

  has_many :destinations_in_trips
  has_many :trips, through: :destinations_in_trips


  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :description, presence: true
  validates :image, presence: true


end
