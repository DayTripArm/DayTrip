class Hero < ApplicationRecord

  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :description, presence: true
  validates :btn_title, presence: true
  validates :btn_link, presence: true
  validates :image, presence: true
  validates :lang, presence: true

end
