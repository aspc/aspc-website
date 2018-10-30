ActiveAdmin.register Department do
  menu false

  permit_params :code, :name
end

