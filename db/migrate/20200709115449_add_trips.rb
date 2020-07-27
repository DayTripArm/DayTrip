class AddTrips < ActiveRecord::Migration[6.0]
  def change
      create_table :trips do |t|
        t.string :title,  null: false, default: ""
        t.text :images, array: true
        t.string :trip_duration,  null: false, default: ""
        t.string :start_location,  null: false, default: ""
        t.text :agenda, null: false, default: ""
        t.text :map_image, array: true
        t.boolean :published, null: false, default: false
        t.datetime :created_at
        t.datetime :updated_at
      end
      create_join_table :destinations, :trips, table_name: :destinations_in_trips do |t|
        t.index :destination_id
        t.index :trip_id
      end

      add_index :trips, :title,  unique: true
  end
end
