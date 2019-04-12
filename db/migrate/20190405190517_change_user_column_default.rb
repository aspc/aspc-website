class ChangeUserColumnDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :role, :integer, :null => false, :default => 0
  end
end
