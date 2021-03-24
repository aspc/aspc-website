class CreateHousingBuildings < ActiveRecord::Migration[5.2]
  def change
    create_table :housing_buildings do |t|
      t.string :name, :null => false, :unique => true
      t.string :slug
      t.integer :floors, :null => false, :default => 1

      t.timestamps
    end

    add_index :housing_buildings, :name, :unique => true

    add_reference :housing_suites, :housing_building, index: true
    add_reference :housing_rooms, :housing_building, index: true

    add_column :housing_rooms, :room_number, :string, :null => false, :unique => true
  end
end
