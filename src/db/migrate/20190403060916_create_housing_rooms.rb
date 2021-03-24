class CreateHousingRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :housing_suites do |t|
      t.integer :suite_type, :null => false, :default => 0

      t.timestamps
    end

    create_table :housing_rooms do |t|
      t.decimal :size, :null => false, :default => 0
      t.integer :occupancy_type, :null => false, :default => 0
      t.integer :closet_type, :null => false, :default => 0
      t.integer :bathroom_type, :null => false, :default => 0

      t.timestamps
    end

    add_reference :housing_rooms, :housing_suite, index: true
  end
end
