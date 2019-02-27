ActiveAdmin.register Static do
  permit_params :title, :subtitle
  
  # Render custom form page with WYSIWYG editor
  controller do
    def edit
      render 'admin/_static_form', :layout =>"active_admin"
    end
  end
  
end