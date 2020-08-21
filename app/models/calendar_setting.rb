class CalendarSetting < ApplicationRecord
  belongs_to :logins, optional: true, :foreign_key => "driver_id"
end
