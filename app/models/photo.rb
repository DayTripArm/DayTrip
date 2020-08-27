class Photo < ApplicationRecord
  belongs_to :login, optional: true

  PROFILE = 1
  CAR = 2
  GOV = 3
  LICENSE = 4

  FILE_TYPES = {"profile_photos" => 1, "car_photos" => 2, "gov_photos" => 3, "license_photos" => 4}
  scope :driver_photos, -> (login_id) { where({login_id: login_id}) }
  attribute :full_path
end
