class AddColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role, :integer, :null => true, :default => :null

    add_index :users, :role
  end
end
