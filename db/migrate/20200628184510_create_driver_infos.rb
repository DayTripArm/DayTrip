class CreateDriverInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :driver_infos do |t|
      t.string :car_type
      t.string :car_mark
      t.string :car_model
      t.string :car_year
      t.string :car_color
      t.integer :car_seats
      t.string :car_specs
    end
    add_reference :driver_infos, :logins, foreign_key: true
  end
end
