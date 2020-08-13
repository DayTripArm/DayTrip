class CreateDriverReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :driver_reviews do |t|
      t.text :review_text
      t.integer :rate
      t.integer :driver_id
      t.integer :traveler_id
      t.timestamps
    end
    add_foreign_key :driver_reviews, :logins, column: :driver_id
    add_foreign_key :driver_reviews, :logins, column: :traveler_id

    add_column :profiles, :is_suspended, :boolean, default: false
    rename_table :reviews, :trip_reviews
  end
end
