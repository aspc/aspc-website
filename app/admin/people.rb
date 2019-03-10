ActiveAdmin.register Person do
  menu :priority => 4, :label => "ASPC Senators and Staff"

  # TODO: allow associating with a user model
  permit_params :name, :position, :role, :email, :biography, :image

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
        if (person.image.attached?)
          image_tag url_for(person.image)
        end
      end
    end
  end

end
