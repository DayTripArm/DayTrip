class Destination < ApplicationRecord

  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :description, presence: true
  validates :image, presence: true


end
