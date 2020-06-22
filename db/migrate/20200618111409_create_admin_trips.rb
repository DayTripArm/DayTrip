class CreateAdminTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :trips do |t|
      ## Database authenticatable
      t.string :title,              null: false, default: ""
      t.text :content, null: false, default: ""
      t.boolean :is_published, null: false, default: false

      ## Rememberable
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :published_at
    end

    add_index :trips, :title,                unique: true
  end
end
