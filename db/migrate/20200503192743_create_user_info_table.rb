class CreateUserInfoTable < ActiveRecord::Migration[6.0]
  def change
    create_table :users_info do |t|
      t.string :name
      t.string :gender
      t.string :date_of_birth
      t.string :phone
      t.text   :about
      t.string :location
      t.string :languages
      t.string :work
      t.boolean :is_deactivated
    end
    add_reference :users_info, :logins, foreign_key: true
  end
end
