class Tip < ApplicationRecord
  belongs_to :tip_category

  validates :title, presence: true
  validates :description, presence: true
  validates :tip_category_id, presence: true
end
