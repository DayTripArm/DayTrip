class RenameDriverInfosForeignKey < ActiveRecord::Migration[6.0]
  def change
    rename_column :driver_infos, :logins_id, :login_id
    add_column :driver_infos, :price_per_km, :integer
    add_column :driver_infos, :driver_destinations, :string
  end
end
