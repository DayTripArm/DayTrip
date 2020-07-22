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
      create_table :destinations_trips, :id => false do |t|
        t.integer :destination_id
        t.integer :trip_id
      end

      add_index :trips, :title,  unique: true
      add_index :destinations_trips, [:destination_id, :trip_id]
  end
end
