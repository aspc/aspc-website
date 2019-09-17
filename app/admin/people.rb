senators_page = Proc.new do
  menu :priority => 5, :label => "ASPC Senators and Staff"

  # TODO: allow associating with a user model
  permit_params :name, :position, :role, :email, :biography, :image, :priority

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
      row :priority
      row :image do |person|
        if (person.image.attached?)
          image_tag url_for(person.image)
        end
      end
    end
  end

end


ActiveAdmin.register Person, :namespace => :admin, &senators_page
ActiveAdmin.register Person, :namespace => :contributor, &senators_page
