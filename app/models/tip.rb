class Tip < ApplicationRecord
  belongs_to :tip_category

  validates :title, presence: true
  validates :lang, presence: true
  validates :description, presence: true
  validates :tip_category_id, presence: true
  scope :exclude_tip_fields, ->  { select( Tip.attribute_names - [ 'tip_category_id']) }
end
