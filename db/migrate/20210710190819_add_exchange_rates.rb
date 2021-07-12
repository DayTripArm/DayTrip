class AddExchangeRates < ActiveRecord::Migration[6.0]
  def change
    create_table :exchange_rates do |t|
      t.string :currency
      t.integer :exchange_rate
      t.datetime :updated_at
    end
  end
end
