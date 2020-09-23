class TipCategory < ApplicationRecord
  has_many :tips

  validates :title, presence: true
  validates :category_type, presence: true

  default_scope -> { order(:id) }

# Tip categories. Each Tip type should be uniq.
  CAR_UPLOAD = 1
  DRIVER_PRICE = 2
  HIT_THE_ROAD_DRIVER = 3
  HIT_THE_ROAD_HOME = 4

  TIPS_TYPE = [['Car upload tip', CAR_UPLOAD], ['Driver price tip', DRIVER_PRICE], ['Hit the Road tip for Drivers', HIT_THE_ROAD_DRIVER], ['Hit the Road tip for Home Page', HIT_THE_ROAD_HOME]]
end
