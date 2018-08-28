class ApplicationController < ActionController::Base
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
    redirect_to sessions_create_path unless logged_in?
  end
end
