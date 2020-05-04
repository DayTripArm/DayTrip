class RemoveExtraColumnsFromLogins < ActiveRecord::Migration[6.0]
  def change
    remove_column :logins, :provider, :string if column_exists?(:logins, :provider)
    remove_column :logins, :uid, :string if column_exists?(:logins, :uid)
    remove_column :logins, :login_type, :int
    remove_column :logins, :reset_password_token, :string if column_exists?(:logins, :reset_password_token)
    remove_column :logins, :reset_password_sent_at, :datetime if column_exists?(:logins, :reset_password_sent_at)
    remove_column :logins, :remember_created_at, :datetime if column_exists?(:logins, :remember_created_at)

    remove_column :logins, :name, :string
    remove_column :logins, :phone, :string
  end
end
