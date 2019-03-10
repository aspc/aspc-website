ActiveAdmin.register Static do
  menu :priority => 3, :label => "Custom Pages"

  permit_params :title, :subtitle

  index :title => "Static Pages" do
    column :title
    column :subtitle
    column :created_at
    column :updated_at
    column :published
    column :last_modified_by
    actions
  end

  form partial: 'static_page_edit_form'

  # Render custom form page with WYSIWYG editor
  controller do
    def show
      redirect_to static_page_path
    end
  end

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