class AddRelationsToBookedTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :booked_trips, :travelers_count, :integer
    add_foreign_key :booked_trips, :logins, column: :driver_id
    add_foreign_key :booked_trips, :logins, column: :traveler_id
    add_foreign_key :booked_trips, :trips, column: :trip_id
    add_index(:booked_trips, [:driver_id, :traveler_id])
  end
end
