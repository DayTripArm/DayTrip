class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :conversation, index: true
      t.references :login, index: true
      t.boolean :read, :default => false
      t.timestamps
    end
  end
end