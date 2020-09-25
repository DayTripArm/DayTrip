class AddRelationsToBookedTrips < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :booked_trips, :logins, column: :driver_id
    add_foreign_key :booked_trips, :logins, column: :traveler_id
    add_foreign_key :booked_trips, :trips, column: :trip_id
  end
end
