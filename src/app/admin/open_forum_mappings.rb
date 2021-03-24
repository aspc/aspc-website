open_forum_mappings = Proc.new do
  menu parent: "Models", :label => "Open Forum"

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :topic, :email

  index :title => 'Open Forum'
end

ActiveAdmin.register OpenForumMapping, :namespace => :admin, &open_forum_mappings