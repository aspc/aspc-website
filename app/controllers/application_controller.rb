class ApplicationController < ActionController::Base
  before_action :setup_application_controller_environment

  helper_method :current_user
  helper_method :is_admin?
  helper_method :logged_in?

  def current_user
    User.find_by_id(session[:current_user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def is_admin?
    return false unless logged_in?
    current_user.is_admin?
  end

  def authenticate_user!
    redirect_to login_path unless logged_in?
  end

  def not_authorized(exception)
    redirect_to unauthorized_path
  end

  private
    def setup_application_controller_environment
      if(Rails.env.development?)
        # Login as a fake user in development mode
        # NOTE: this user will _never_ be available in production
        dev_user = User.find_or_create_by(:email => "dev_user@pomonastudents.org",
                                          :first_name => "dev_user",
                                          :is_cas_authenticated => false,
                                          :is_admin => true,
                                          :role => :admin,
                                          :school => :pomona,
                                          :password => "dev_password");

        session[:current_user_id] = dev_user.id
      end
    end
end
