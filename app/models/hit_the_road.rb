class HitTheRoad < ApplicationRecord

  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates :description, presence: true
  validates :image, presence: true
  validates :lang, presence: true
  scope :active_hit_the_road, ->(lang) {where({published: true, lang: lang}).first}
end
