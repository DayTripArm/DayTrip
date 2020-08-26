class ChangeUsersStatus < ActiveRecord::Migration[6.0]
  def change
    remove_column :profiles, :is_suspended, :boolean
    remove_column :profiles, :is_deactivated, :boolean
    add_column :profiles, :status, :integer, default: 0
  end
end
