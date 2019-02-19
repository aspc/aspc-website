ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  page_action :import_menus, method: :get do
    # Imports all of the dining hall menus
    MenuImportJob.perform_later

    redirect_to admin_dashboard_path
  end

  page_action :import_frank, method: :get do
    MenuImportJobs::FrankMenuImportJob.perform_now
    redirect_to admin_dashboard_path
  end
  page_action :import_frary, method: :get do
    MenuImportJobs::FraryMenuImportJob.perform_now
    redirect_to admin_dashboard_path
  end
  page_action :import_oldenborg, method: :get do
    MenuImportJobs::OldenborgMenuImportJob.perform_now
    redirect_to admin_dashboard_path
  end
  page_action :import_cmc, method: :get do
    MenuImportJobs::ClaremontMckennaMenuImportJob.perform_now
    redirect_to admin_dashboard_path
  end
  page_action :import_hmc, method: :get do
    MenuImportJobs::HarveyMuddMenuImportJob.perform_now
    redirect_to admin_dashboard_path
  end
  page_action :import_scripps, method: :get do
    MenuImportJobs::ScrippsMenuImportJob.perform_now
    redirect_to admin_dashboard_path
  end
  page_action :import_pitzer, method: :get do
    MenuImportJobs::PitzerMenuImportJob.perform_now
    redirect_to admin_dashboard_path
  end

  page_action :import_course_data, method: :get do
    CourseImportJob.perform_now
    redirect_to admin_dashboard_path
  end

  page_action :import_events, method: :get do
    EventImportJob.perform_now
    redirect_to admin_dashboard_path
  end

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
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

      column do
        panel "Events Import" do
          para "Last imported at #{Event.where(:source => :facebook).order(:created_at).last.try :created_at}"

          form :action => admin_dashboard_import_events_path do
            button "Import Events", :type => "submit"
          end
        end
      end
    end
  end
end
