ActiveAdmin.register Static do
  permit_params :title, :subtitle

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
  
  # Allow admins to approve content and publish live
  batch_action :approve do |ids|
    batch_action_collection.find(ids).each do |static|
      static.approve!
    end
    redirect_to collection_path, alert: "The pages have been approved."
  end

  # Allow admins to approve content and publish live
  # member_action :approve, method: :get do
  #   static = Static.find_by_id(params[:id])
  #   static.approve!
  #   # redirect_to static_admin_path, notice: "Updates approved!"
  # end

  # action_item do
  #   link_to "Approve changes", approve_admin_static_path
  # end
  
end