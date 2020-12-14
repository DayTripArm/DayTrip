class DriverInfo < ApplicationRecord
  belongs_to :logins, optional: true
  scope :car_details, -> {select("id, car_type, car_mark, car_model, car_year, car_color")}
  scope :more_details, -> {select("id, car_seats, car_specs, driver_destinations")}
  scope :prices, -> {select("id, tariff1,tariff2, hit_the_road_tariff")}
end
