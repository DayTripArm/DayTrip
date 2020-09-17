class AddDriverTariffForWholeDay < ActiveRecord::Migration[6.0]
  def change
    add_column :driver_infos, :hit_the_road_tariff, :integer
  end
end
