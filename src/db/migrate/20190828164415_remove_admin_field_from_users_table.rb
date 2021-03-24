class RemoveAdminFieldFromUsersTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :is_admin, :boolean
    change_column_null :users, :role, false
  end
end
