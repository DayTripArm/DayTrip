class CreateSavedTrips < ActiveRecord::Migration[6.0]
  def change
    create_join_table :logins, :trips, table_name: :saved_trips do |t|
      t.index :login_id
      t.index :trip_id
    end
  end
end
