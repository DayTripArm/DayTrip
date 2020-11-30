class Destination < ApplicationRecord
  has_many :destinations_in_trips, :dependent => :destroy
  has_many :trips, through: :destinations_in_trips, :dependent => :destroy

  self.ignored_columns = %w(created_at updated_at)
  mount_uploader :image, ImageUploader

  validates :title, presence: true
  validates_uniqueness_of :title
  validates :description, presence: true
  validates :image, presence: true
  validates :lang, presence: true


  scope :published, ->  { where(:published => true) }
end
