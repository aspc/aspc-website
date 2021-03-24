departments_page = Proc.new do
  menu false

  permit_params :code, :name
end

ActiveAdmin.register Department, :namespace => :admin, &departments_page

