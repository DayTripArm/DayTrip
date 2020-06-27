class AddDriverPreregColumn < ActiveRecord::Migration[6.0]
  def up
    add_column :logins, :is_prereg, :boolean
  end
  def down
    remove_column :logins, :is_prereg, :boolean
  end
end
