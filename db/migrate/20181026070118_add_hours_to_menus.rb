class AddHoursToMenus < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :hours, :string
  end
end
