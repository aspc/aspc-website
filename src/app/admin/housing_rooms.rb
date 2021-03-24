housing_room_page = Proc.new do
  menu parent: "Models"

  permit_params :room_number, :size, :occupancy_type, :closet_type, :bathroom_type, :housing_building_id, :housing_suite_id, :room_number
end

ActiveAdmin.register HousingRoom, :namespace => :admin, &housing_room_page