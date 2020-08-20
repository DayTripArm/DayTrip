namespace :import do
  require 'csv'
  desc "Imports a worldcities.csv file into an DB (CountryCities table)"
  task country_cities: :environment do
    puts "Starting import process worldcities.csv into DB. Please wait..."

    CSV.foreach(File.join("public", "worldcities.csv"), encoding:'iso-8859-1:utf-8', :headers => true) do |row|
      CountryCity.create!(row.to_hash)
    end

    puts "Done."
  end

end
