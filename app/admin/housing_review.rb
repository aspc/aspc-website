housing_review_page = Proc.new do
  menu parent: "Models"

  form do |f|
    f.inputs
    f.input :image, :as => :file
    f.actions
  end

  permit_params :overall_rating, :layout_rating, :temperature_rating, :comments, :housing_room_id, :image
end

ActiveAdmin.register HousingReview, :namespace => :admin, &housing_review_page