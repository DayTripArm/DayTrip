class CreateLogins < ActiveRecord::Migration[6.0]
  def change
    create_table :logins do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.integer :user_type
      t.integer :login_type

      t.timestamps
    end
  end
end
