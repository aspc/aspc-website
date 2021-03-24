insturctors_page = Proc.new do
  menu parent: "Models"

  permit_params :name
end

ActiveAdmin.register Instructor, :namespace => :admin, &insturctors_page
