ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  page_action :import_menus, method: :get do
    system "rake menu_import:pitzer"
    system "rake menu_import:claremont_mckenna"
    system "rake menu_import:scripps"
    system "rake menu_import:harvey_mudd"
    system "rake menu_import:frank"
    system "rake menu_import:frary"

    redirect_to admin_dashboard_path
  end

  page_action :import_frank, method: :get do
    system "rake menu_import:frank"
    redirect_to admin_dashboard_path
  end
  page_action :import_frary, method: :get do
    system "rake menu_import:frary"
    redirect_to admin_dashboard_path
  end
  page_action :import_cmc, method: :get do
    system "rake menu_import:claremont_mckenna"
    redirect_to admin_dashboard_path
  end
  page_action :import_hmc, method: :get do
    system "rake menu_import:harvey_mudd"
    redirect_to admin_dashboard_path
  end
  page_action :import_scripps, method: :get do
    system "rake menu_import:scripps"
    redirect_to admin_dashboard_path
  end
  page_action :import_pitzer, method: :get do
    system "rake menu_import:pitzer"
    redirect_to admin_dashboard_path
  end

  page_action :import_course_data, method: :get do
    system "rake course_import:academic_terms"
    system "rake course_import:departments"
    system "rake course_import:courses"

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
