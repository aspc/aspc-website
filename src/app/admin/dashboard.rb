admin_dashboard_page = Proc.new do
  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  page_action :import_menus, method: :get do
    # Imports all of the dining hall menus
    MenuImportJob.perform_later
    redirect_to admin_dashboard_path, notice: "Importing all menus!"
  end

  page_action :import_frank, method: :get do
    MenuImportJobs::FrankMenuImportJob.perform_later
    redirect_to admin_dashboard_path, notice: "Importing Frank menus!"
  end
  page_action :import_frary, method: :get do
    MenuImportJobs::FraryMenuImportJob.perform_later
    redirect_to admin_dashboard_path, notice: "Importing Frary menus!"
  end
  page_action :import_oldenborg, method: :get do
    MenuImportJobs::OldenborgMenuImportJob.perform_later
    redirect_to admin_dashboard_path, notice: "Importing Oldenborg menus!"
  end
  page_action :import_cmc, method: :get do
    MenuImportJobs::ClaremontMckennaMenuImportJob.perform_later
    redirect_to admin_dashboard_path, notice: "Importing Claremont McKenna menus!"
  end
  page_action :import_hmc, method: :get do
    MenuImportJobs::HarveyMuddMenuImportJob.perform_later
    redirect_to admin_dashboard_path, notice: "Importing Harvey Mudd menus!"
  end
  page_action :import_scripps, method: :get do
    MenuImportJobs::ScrippsMenuImportJob.perform_later
    redirect_to admin_dashboard_path, notice: "Importing Scripps menus!"
  end
  page_action :import_pitzer, method: :get do
    MenuImportJobs::PitzerMenuImportJob.perform_later
    redirect_to admin_dashboard_path, notice: "Importing Pitzer menus!"
  end

  page_action :import_course_data, method: :get do
    CourseImportJob.perform_later
    redirect_to admin_dashboard_path, notice: "Importing courses! It might take some time before courses are updated."
  end

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        para "Welcome to the Admin Dashboard. You have full access to the ASPC Website."
        para "Some frequent tasks are available below:"
      end
    end

    columns do
      column do
        panel "Course Import" do
          para "Last imported at #{Course.order(:created_at).last.try :created_at}"

          form :action => admin_dashboard_import_course_data_path do
            button "Import All Course Data", :type => "submit"
          end
        end
      end

      column do
        panel "Menu Import" do
          para "Last imported at #{MenuItem.order(:created_at).last.try :created_at}"

          form :action => admin_dashboard_import_menus_path do
            button "Import All Menus", :type => "submit"
          end

          br
          hr

          form :action => admin_dashboard_import_frank_path do
            button "Import Frank Menu", :type => "submit"
          end
          br
          form :action => admin_dashboard_import_frary_path do
            button "Import Frary Menu", :type => "submit"
          end
          br
          form :action => admin_dashboard_import_oldenborg_path do
            button "Import Oldenborg Menu", :type => "submit"
          end
          br
          form :action => admin_dashboard_import_cmc_path do
            button "Import CMC Menu", :type => "submit"
          end
          br
          form :action => admin_dashboard_import_hmc_path do
            button "Import HMC Menu", :type => "submit"
          end
          br
          form :action => admin_dashboard_import_scripps_path do
            button "Import Scripps Menu", :type => "submit"
          end
          br
          form :action => admin_dashboard_import_pitzer_path do
            button "Import Pitzer Menu", :type => "submit"
          end
        end
      end
    end
  end
end

contributor_dashboard_page = Proc.new do
  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  page_action :new_custom_page, method: :get do
    redirect_to new_contributor_static_path
  end

  page_action :show_events, method: :get do
    redirect_to contributor_events_path
  end

  page_action :new_announcement, method: :get do
    redirect_to new_contributor_announcement_path
  end


  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        para "Welcome to the Contributor Dashboard. You have access to certain administrative features of the ASPC Website."
        para "Some frequent tasks are available below:"
      end
    end

    columns do
      column do
        panel "Page Creation" do
          para "You have the ability to create and edit pages. Simply navigate to the 'Custom Pages' tab to edit an existing page or create a new page by clicking the button below."
          para "Once you create a page, it will be submitted for review to be approved by someone on the software team."
          form :action => contributor_dashboard_new_custom_page_path do
            button "Create New Page", :type => "submit"
          end
        end
      end

      column do
        panel "Event Moderation" do
          para "You have the ability to review and approve submitted events. Simply navigate to the 'Event Moderation' tab to check out the events."

          form :action => contributor_dashboard_show_events_path do
            button "View Submitted Events", :type => "submit"
          end
        end
      end

      column do
        panel "Announcements" do
          para "To create or edit a new announcement on the home page, navigate to 'Announcements' or click the button below."
          form :action => contributor_dashboard_new_announcement_path do
            button "Create New Announcement", :type => "submit"
          end
        end
      end
    end
  end
end

ActiveAdmin.register_page "Dashboard", :namespace => :admin, &admin_dashboard_page
ActiveAdmin.register_page "Dashboard", :namespace => :contributor, &contributor_dashboard_page

#ActiveAdmin.register_page "Dashboard", :namespace => :contributor do
#  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }


#  title "Welcome, contributors!"
#  body  "This dashboard is intended to allow Senate and Staff Committees to create and edit new pages in a quick and easy manner"
#end
