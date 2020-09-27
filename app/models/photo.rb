class Photo < ApplicationRecord
  belongs_to :login, optional: true
  has_many :booked_trips

  PROFILE = 1
  CAR = 2
  GOV = 3
  LICENSE = 4
  REG_CARD = 5

  FILE_TYPES = {"profile_photos" => 1, "car_photos" => 2, "gov_photos" => 3, "license_photos" => 4, "reg_card_photos" => 5}
  scope :user_photos_by_file_type, -> (login_id, file_type) { where({login_id: login_id, file_type: file_type}) }
  scope :get_by_file_type, -> (file_type) { where({file_type: file_type}) }
  attribute :full_path
end
