class AddDriverTariffForWholeDay < ActiveRecord::Migration[6.0]
  def change
    add_column :driver_infos, :hit_the_road_tariff, :integer
    change_column :calendar_settings, :unavailable_days, :json, default: {excluded_days: []}
    change_column :calendar_settings, :advance_notice, :integer, default: 0
  end
end
