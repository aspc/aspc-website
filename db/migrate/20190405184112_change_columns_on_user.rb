class ChangeColumnsOnUser < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :role, false, 0
  end
end
