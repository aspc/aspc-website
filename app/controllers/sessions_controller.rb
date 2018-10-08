require 'cgi'

class SessionsController < ApplicationController
  PHP_AUTH_URL = 'https://aspc.pomona.edu/php-auth'

  def destroy
    session[:current_user_id] = nil
  end

  def not_authorized
  end

  def create
    # We have different post-authentication endpoints depending on staging / production environments
    root_domain = if request.subdomains.first == 'staging'
                  then 'staging.aspc.pomona.edu'
                  else 'aspc.pomonastudents.org'
                  end

    next_page = '/'
    service_url = 'https://' + root_domain + Rails.application.routes.url_helpers.login_path + '?next=' + CGI::escape(next_page) # request.host + request.path
    ticket = params[:ticket]

    # if request doesn't have CAS Ticket, direct them there
    return redirect_to _login_url(service_url) unless ticket

    # otherwise attempt login
    user_info = SessionsService.authenticate_ticket(ticket, service_url)

    # if CAS Ticket is invalid, redirect to CAS ticketing system
    return redirect_to _login_url(service_url) unless user_info

    # otherwise, login was successful, so
    # find or create user from login data
    user = User.find_by(:email => user_info[:email])
    if user.nil?
      user = User.create({
        :email => user_info[:email],
        :first_name => user_info[:first_name],
        :is_cas_authenticated => true
      })
    end

    # then create the login session for the user
    session[:current_user_id] = user.id

    # TODO: complete PHP session login/authentication and redirect user
    # return redirect_to PHP_AUTH_URL
    flash.now[:notice] = "Welcome, #{current_user.first_name}"
    redirect_to root_url
  end

  def _login_url(service_url)
    query_params = {
      :service => service_url
    }

    cas_server_url = Rails.application.credentials[:cas_settings][:server_url]
    [cas_server_url, 'login'].join('/') + '?' + query_params.to_query.to_s
  end
end
