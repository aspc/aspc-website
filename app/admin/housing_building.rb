housing_building_page = Proc.new do
  menu parent: "Models"

  permit_params :name, :slug, :floor
end

ActiveAdmin.register HousingBuilding, :namespace => :admin, &housing_building_page