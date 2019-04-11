housing_review_page = Proc.new do
  menu parent: "Models"

  permit_params :overall_rating, :layout_rating, :temperature_rating, :comments, :housing_room_id
end

ActiveAdmin.register HousingReview, :namespace => :admin, &housing_review_page