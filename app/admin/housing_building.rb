housing_building_page = Proc.new do
  menu parent: "Models"

  permit_params :name, :slug,:description, :floor, :image1, :image2, :image3, :image4, :image5, floor_plans: []

  form do |f|
    f.inputs
    f.input :image1, :as => :file
    f.input :image2, :as => :file
    f.input :image3, :as => :file
    f.input :image4, :as => :file
    f.input :image5, :as => :file
    f.input: floor_plans, :as => :file, input_html: { multiple: true }
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :slug

      row :description
      row :floor
      row :image1 do |building|
        image_tag url_for(building.image1), :width => '50%'
      end
      row :image2 do |building|
        image_tag url_for(building.image2), :width => '50%'
      end
      row :image3 do |building|
        image_tag url_for(building.image3), :width => '50%'
      end
      row :image4 do |building|
        image_tag url_for(building.image4), :width => '50%'
      end
      row :image5 do |building|
        image_tag url_for(building.image5), :width => '50%'
      end
      row :floor_plans do |building|
        building.floor_plans.each do |plan|
          span do
            link_to plan.filename, url_for(plan)
          end
        end
      end
    end
  end

end

ActiveAdmin.register HousingBuilding, :namespace => :admin, &housing_building_page