class AddTips < ActiveRecord::Migration[6.0]
  def change
    create_table :tip_categories do |t|
      t.string :title,  null: false, default: ""
	  t.integer :category_type, null: false
    end

    create_table :tips do |t|
      t.string :title,  null: false, default: ""
      t.text :description, null: false, default: ""
      t.belongs_to :tip_category, index: true, foreign_key: true
    end

    add_index :tip_categories, :title,  unique: true
    add_index :tips, :title,  unique: true
  end
end
