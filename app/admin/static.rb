custom_pages_page = Proc.new do
  menu :priority => 3, :label => "Custom Pages"

  # Change "new" button name
  config.clear_action_items!
  action_item :only => :index do
    redirect_url = new_polymorphic_path([current_user.role.to_sym, Static])
    link_to "New Page" , redirect_url
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

  form partial: 'admin/statics/static_page_edit_form'

  # Render custom form page with WYSIWYG editor
  controller do
    def show
      redirect_to static_page_path
    end

    def create
      create! do |format|
        redirect_url = edit_polymorphic_path([current_user.role.to_sym, resource])
        format.html do redirect_to redirect_url end
      end
    end

    def destroy
      redirect_url = polymorphic_path([current_user.role.to_sym, Static])
      if current_user.role.to_sym == :admin
        destroy! { redirect_url }
      else
        redirect_to redirect_url, alert: "Only admins may delete pages. If you've accidentally created a page you no longer need, let the software team know."
      end
    end
  end

  # Allow admins to approve content and publish live
  config.clear_batch_actions!
  batch_action :approve do |ids|
    unless current_user.role.to_sym == :admin
      redirect_to collection_path, alert: "Only admins may approve pages. Please notify the software team if you would like your page published as soon as possible."
    else
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
  end
end

ActiveAdmin.register Static, :namespace => :admin, &custom_pages_page
ActiveAdmin.register Static, :namespace => :contributor, &custom_pages_page