class AddOmniauthToLogins < ActiveRecord::Migration[6.0]
  def change
    add_column :logins, :provider, :string
    add_column :logins, :uid, :string
  end
end
