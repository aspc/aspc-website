announcements_page = Proc.new do
  menu :priority => 2
  permit_params :title, :caption, :background_image, :details_url

  form do |f|
    f.inputs
    f.input :background_image, :as => :file
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :caption
      row :details_url
      row :background_image do |announcement|
        image_tag url_for(announcement.background_image), :width => '100%'
      end
    end
  end

end

ActiveAdmin.register Announcement, :namespace => :admin, &announcements_page
ActiveAdmin.register Announcement, :namespace => :contributor, &announcements_page
