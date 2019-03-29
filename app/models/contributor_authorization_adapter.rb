class ContributorAuthorizationAdapter < ActiveAdmin::AuthorizationAdapter

  # Contributor role is a subset of the Admin role
  def authorized?(action, subject = nil)
    user.is_admin? && (user.role.to_sym == :contributor || user.role.to_sym == :admin)
  end

end