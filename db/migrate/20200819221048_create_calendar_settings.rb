class CreateCalendarSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :calendar_settings do |t|
      t.integer :advance_notice
      t.integer :availability_window
      t.integer :driver_id
    end
    add_foreign_key :calendar_settings, :logins, column: :driver_id
  end
end
