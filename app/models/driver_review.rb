class DriverReview < ApplicationRecord
  belongs_to :login, optional: true, foreign_key: :driver_id
end
