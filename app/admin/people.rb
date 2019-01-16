ActiveAdmin.register Person do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :name, :position, :role, :email, :biography, :image

  menu label: "ASPC People"

  form do |f|
    f.inputs
    f.input :image, :as => :file
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :position
      row :role
      row :email
      row :biography
      row :image do |person|
        image_tag url_for(person.image)
      end
    end
  end

end
