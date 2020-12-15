class AddRelationReviewsToBookedTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :driver_reviews, :booked_trip_id, :integer
    add_column :trip_reviews, :booked_trip_id, :integer
    add_foreign_key :driver_reviews, :booked_trips, column: :booked_trip_id
    add_foreign_key :trip_reviews, :booked_trips, column: :booked_trip_id
  end
end
