class CustomersFile < ApplicationRecord
  belongs_to :logins
  FILE_TYPES = {"profile" => 1, "cars" => 2, "gov_id" => 3, "license" => 4}
end
