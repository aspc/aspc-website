class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.integer :dining_hall, :null => false
      t.integer :meal_type, :null => false
      t.integer :day, :null => false

      t.timestamps
    end
  end
end
