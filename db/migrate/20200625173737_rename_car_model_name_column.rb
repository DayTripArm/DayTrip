class RenameCarModelNameColumn < ActiveRecord::Migration[6.0]
  def change
    execute "DROP TABLE IF EXISTS car_brands;"
    execute "DROP TABLE IF EXISTS car_models;"
    execute "DROP SEQUENCE IF EXISTS car_brands_seq;"
    execute "DROP SEQUENCE IF EXISTS car_models_seq;"
    connection = ActiveRecord::Base.connection

    sql = File.read('db/cars.sql')
    statements = sql.encode('UTF-8').split(/;$/)
    statements.pop
    ActiveRecord::Base.transaction do
      statements.each do |statement|
        connection.execute(statement)
      end
    end
  end
end
