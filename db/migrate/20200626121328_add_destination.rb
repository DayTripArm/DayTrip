class AddDestination < ActiveRecord::Migration[6.0]
  def change
    create_table :destinations do |t|
      t.string :title,  null: false, default: ""
      t.text :description, null: false, default: ""
      t.string :image, null: false, default: ""
      t.boolean :published, null: false, default: false
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :destinations, :title,  unique: true
  end
end
