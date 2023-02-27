class AddDescriptionToHousingBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :housing_buildings, :description, :string
  end
end
