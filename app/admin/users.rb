user_page = Proc.new do
  menu parent: "Models"

  permit_params :email, :first_name, :is_cas_authenticated, :role, :school

  member_action :impersonate, method: :post do
    session[:current_user_id] = resource.id
    redirect_to root_path, :flash => {
      :notice => "Logged in as #{resource.email}",
      :notice_subtitle => "Log out when finished to access your real account.",
      :notice_class => "is-danger"
    }
  end

  action_item :impersonate, only: %i[show] do
    button_to "Impersontate", impersonate_admin_user_path
  end
end

ActiveAdmin.register User, :namespace => :admin, &user_page
