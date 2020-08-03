class AddReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.text :review_text
      t.integer :rate
      t.integer :login_id
      t.integer :trip_id
      t.timestamp :created_at
    end
    add_foreign_key :reviews, :logins, column: :login_id
    add_foreign_key :reviews, :trips, column: :trip_id
  end
end
