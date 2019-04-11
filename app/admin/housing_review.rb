ActiveAdmin.register HousingReview do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

permit_params :overall_rating, :layout_rating, :temperature_rating, :comments, :housing_room_id

end
