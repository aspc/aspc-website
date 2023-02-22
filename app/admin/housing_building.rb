housing_building_page = Proc.new do
  menu parent: "Models"

  permit_params :name, :slug, :floor, :descrip, :image

  form do |f|
    f.inputs
    f.input :image, :as => :file
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :slug
      row :floor
      row: descrip
      row :image do |building|
        image_tag url_for(building.image), :width => '50%'
      end
    end
  end

end

ActiveAdmin.register HousingBuilding, :namespace => :admin, &housing_building_page