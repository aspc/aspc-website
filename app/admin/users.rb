user_page = Proc.new do
  menu parent: "Models"

  permit_params :email, :first_name, :is_cas_authenticated, :is_admin, :school
end

ActiveAdmin.register User, :namespace => :admin, &user_page
