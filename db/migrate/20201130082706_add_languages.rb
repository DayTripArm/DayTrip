class AddLanguages < ActiveRecord::Migration[6.0]
  def change
    add_column :destinations, :lang, :string
    add_column :heros, :lang, :string
    add_column :hit_the_roads, :lang, :string
    add_column :tip_categories, :lang, :string
    add_column :tips, :lang, :string
    add_column :trips, :lang, :string
  end
end
