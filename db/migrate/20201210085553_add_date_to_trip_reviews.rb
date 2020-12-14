class AddDateToTripReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :trip_reviews, :trip_date, :date
  end
end
