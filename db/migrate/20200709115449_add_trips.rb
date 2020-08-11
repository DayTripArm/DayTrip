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
        t.boolean :is_top_choice, null: false, default: false
        t.datetime :created_at
        t.datetime :updated_at
      end
      create_table :destinations_in_trips do |t|
        t.string :stops_title,  null: false, default: ""
        t.references :destination, foreign_key: true
        t.references :trip, foreign_key: true
      end

      add_index :trips, :title,  unique: true
  end
end
