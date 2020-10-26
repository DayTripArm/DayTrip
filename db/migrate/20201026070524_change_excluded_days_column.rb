class ChangeExcludedDaysColumn < ActiveRecord::Migration[6.0]
  def up
    CalendarSetting.find_each do |setting|
      setting.unavailable_days["included_days"] = setting.unavailable_days["excluded_days"]
      setting.unavailable_days.delete("excluded_days")
      setting.save!
    end
    rename_column :calendar_settings, :unavailable_days, :available_days
    change_column :calendar_settings, :available_days, :json, default: {included_days: []}
  end

  def down
    CalendarSetting.find_each do |setting|
      setting.available_days["excluded_days"] = setting.available_days["included_days"]
      setting.available_days.delete("included_days")
      setting.save!
    end
    rename_column :calendar_settings, :available_days, :unavailable_days
    change_column :calendar_settings, :unavailable_days, :json, default: {excluded_days: []}
  end
end
