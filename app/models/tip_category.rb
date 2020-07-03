class TipCategory < ApplicationRecord
  has_many :tips

  validates :title, presence: true
  validates :category_type, presence: true

  default_scope -> { order(:id) }

  scope :exclude_fields, ->  { select( Tip.attribute_names - [ 'tip_category_id'] + TipCategory.attribute_names ) }
  scope :tip_title_alias, ->  { select('"tips"."title" AS "tip_title"') }
# Tip categories. Each Tip type should be uniq.
  CAR_UPLOAD = 1
  DRIVER_PRICE = 2

  TIPS_TYPE = [['Car upload tip', CAR_UPLOAD], ['Driver price tip', DRIVER_PRICE]]
end
