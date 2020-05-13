class ChangeLoginInfosToProfile < ActiveRecord::Migration[6.0]
  def change
    rename_table :login_infos, :profiles
    rename_column :profiles, :logins_id, :login_id
  end
end
