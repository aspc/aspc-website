class ChangeRoleDefaultVaulePeople < ActiveRecord::Migration[5.2]
  def change
    change_column_default :people, :role, 0
  end
end
