class Photo < ApplicationRecord
  belongs_to :login, optional: true
  FILE_TYPES = {"profile_photos" => 1, "car_photos" => 2, "gov_photos" => 3, "license_photos" => 4}
  scope :car_photos, -> (login_id) { where({login_id: login_id, file_type:  FILE_TYPES["car_photos"]}) }
end
