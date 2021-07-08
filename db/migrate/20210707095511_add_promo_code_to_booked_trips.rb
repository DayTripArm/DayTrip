class AddPromoCodeToBookedTrips < ActiveRecord::Migration[6.0]
  def change
    add_column :booked_trips, :promo_code, :string
  end
end
