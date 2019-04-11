ActiveAdmin.register HousingRoom do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

permit_params :room_number, :size, :occupancy_type, :closet_type, :bathroom_type, :housing_building_id, :housing_suite_id, :room_number

end
