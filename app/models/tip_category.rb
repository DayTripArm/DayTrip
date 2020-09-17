class TipCategory < ApplicationRecord
  has_many :tips

  validates :title, presence: true
  validates :category_type, presence: true

  default_scope -> { order(:id) }

# Tip categories. Each Tip type should be uniq.
  CAR_UPLOAD = 1
  DRIVER_PRICE = 2
  HIT_THE_ROAD = 3

  TIPS_TYPE = [['Car upload tip', CAR_UPLOAD], ['Driver price tip', DRIVER_PRICE], ['Hit the Road tip', HIT_THE_ROAD]]
end
