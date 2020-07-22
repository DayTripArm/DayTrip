class RenameFilesTableToPhotos < ActiveRecord::Migration[6.0]
  def change
    rename_table :customers_files, :photos
    rename_column :photos, :logins_id, :login_id
    rename_column :driver_infos, :price_per_km, :tariff1
    add_column :driver_infos, :tariff2, :integer
  end
end
