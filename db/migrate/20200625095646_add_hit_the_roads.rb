class AddHitTheRoads < ActiveRecord::Migration[6.0]
  def change
    create_table :hit_the_roads do |t|
      t.string :title,  null: false, default: ""
      t.text :description, null: false, default: ""
      t.string :image, null: false, default: ""
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :hit_the_roads, :title,  unique: true
  end
end
