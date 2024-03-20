housing_review_page = Proc.new do
  menu parent: "Models"

  form do |f|
    f.inputs
    f.input :images, :as => :file, input_html: { multiple: true }
    f.actions
  end

  permit_params :overall_rating, :layout_rating, :temperature_rating, :comments, :housing_room_id, images: []
end

ActiveAdmin.register HousingReview, :namespace => :admin, &housing_review_page