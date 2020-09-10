class CreateBookedTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :booked_trips do |t|
      t.integer :trip_id
      t.integer :driver_id
      t.integer :traveler_id
      t.integer :price
      t.string :pickup_location
      t.time :pickup_time
      t.text :notes
      t.date :trip_day
    end
    add_column :calendar_settings, :unavailable_days, :json
  end
end
