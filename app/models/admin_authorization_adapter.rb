class AdminAuthorizationAdapter < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)
    user.is_admin? && user.role.to_sym == :admin
  end

end