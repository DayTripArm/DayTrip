class Photo < ApplicationRecord
  belongs_to :login, optional: true
  FILE_TYPES = {"profile_photos" => 1, "cars_photos" => 2, "gov_photos" => 3, "license_photos" => 4}
end
