ActiveAdmin.register Static do
  permit_params :title, :subtitle
  # actions :index, :show, :create, :edit, :update, :destroy, :approve

  # index do
  #   column :all
  #   actions defaults: true do |page|
  #     link_to "custom action", "http://example.org"
  #   end
  # end

  form do |f|
    inputs 'Static' do
      f.input :title
      f.input :subtitle
    end
    f.semantic_errors
    f.actions
  end

  # Render HTML content in view
  show do
    render "admin/static_view", { :layout => "active_admin", :page => Static.find_by_id(params[:id]) }
    # redirect_to controller: "static", action: "show", id: params[:id]
  end
  
  # Render custom form page with WYSIWYG editor
  controller do
    def edit
      render "admin/_static_form", layout: "active_admin", locals: { page: Static.find_by_id(params[:id]) }
    end
  end

  # action_item :view, only: :show do
  #   link_to 'View on site', :controller => :static, :action => :show
  # end

  # action_item :edit_content, only: :show do
  #   # link_to("Edit page content", render("admin/static_form", { layout: "active_admin", page: Static.find_by_id(params[:id]) }))
  #   link_to("Edit page content", edit_admin_static_path(params[:id]))
  # end
  
  # Allow admins to approve content and publish live
  batch_action :approve do |ids|
    batch_action_collection.find(ids).each do |static|
      static.approve!
    end
    redirect_to collection_path, alert: "The pages have been approved."
  end

  # action_item do
  #   link_to "Approve changes", approve_admin_static_path
  # end
  
end