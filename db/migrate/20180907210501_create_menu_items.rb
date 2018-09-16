class CreateMenuItems < ActiveRecord::Migration[5.2]
  def change
    create_table :menu_items do |t|
      t.text :name, :null => false
      t.string :station
      t.string :image_url

      t.timestamps
    end

    add_index :menu_items, :name
    add_index :menu_items, :station
    add_reference :menu_items, :menu, index: true
  end
end
