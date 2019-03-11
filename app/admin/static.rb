ActiveAdmin.register Static do
  menu :priority => 3, :label => "Custom Pages"

  # Change "new" button name
  config.clear_action_items!
  action_item :only => :index do
    link_to "New Page" , new_admin_static_path
  end

  permit_params :title, :subtitle, :page_name

  index :title => "Static Pages" do
    selectable_column

    column :title
    column :subtitle
    column :page_name
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

    def create
      create! do |format|
        format.html { redirect_to edit_admin_static_path(:id => resource.id) }
      end
    end
  end

  # Allow admins to approve content and publish live
  batch_action :approve do |ids|
    validation_error_messages = []
    batch_action_collection.find(ids).each do |page|
      did_approve = page.approve!

      if not did_approve
        validation_error_messages.concat page.errors.full_messages.map { |msg| "Page #{page.id}: #{msg}" }
      end
    end

    if validation_error_messages.blank?
      redirect_to collection_path, alert: "The pages have been approved."
    else
      redirect_to collection_path, alert: validation_error_messages.join(',')
    end
  end

  # action_item do
  #   link_to "Approve changes", approve_admin_static_path
  # end
  
end