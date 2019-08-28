class ContributorAuthorizationAdapter < ActiveAdmin::AuthorizationAdapter

  # Contributor role is a subset of the Admin role
  def authorized?(action, subject = nil)
    user.contributor? || user.admin?
  end

end