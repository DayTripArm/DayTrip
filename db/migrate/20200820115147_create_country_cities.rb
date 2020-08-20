class CreateCountryCities < ActiveRecord::Migration[5.1]
  def self.up
    create_table :country_cities do |t|
      t.string :country
      t.string :city
    end
  end

  def self.down
    drop_table :country_cities
  end
end
