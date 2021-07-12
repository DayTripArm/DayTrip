class ExchangeRate < ApplicationRecord
  validates :currency, uniqueness: { message: "%{value} currency is already set" }
  validates :exchange_rate, presence: true
  validates :exchange_rate, numericality: { message: "field should be numerical" }

end