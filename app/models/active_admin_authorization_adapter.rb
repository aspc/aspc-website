# app/models/only_authors_authorization.rb
class ActiveAdminAuthorizationAdapter < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)
    user.is_admin?
  end

end