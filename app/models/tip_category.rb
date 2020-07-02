class TipCategory < ApplicationRecord
  has_many :tips

  validates :title, presence: true

  default_scope -> { order(:id) }
end
