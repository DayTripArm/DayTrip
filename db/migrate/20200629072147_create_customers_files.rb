class CreateCustomersFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :customers_files do |t|
      t.string :name
      t.integer :file_type
    end
    add_reference :customers_files, :logins, foreign_key: true
  end
end
