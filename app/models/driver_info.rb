class DriverInfo < ApplicationRecord
  belongs_to :logins, optional: true
end
