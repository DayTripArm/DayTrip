class CalendarSetting < ApplicationRecord
  belongs_to :logins, optional: true, :foreign_key => "driver_id"
  serialize :unavailable_days, Array
end
