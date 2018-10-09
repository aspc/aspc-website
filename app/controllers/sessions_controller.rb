require 'cgi'

class SessionsController < ApplicationController
  PHP_AUTH_URL = 'https://aspc.pomona.edu/php-auth'

  def new
  end

  def destroy
    session[:current_user_id] = nil
  end

  def not_authorized
  end

  def create_new_account
    email = params[:email]
    user = User.find_by(:email => email)

    if(user)
      return redirect_to login_url,
                         :flash => {
                             :notice => "Cannot create account",
                             :notice_subtitle => "Account with provided email already exists.",
                             :notice_class => "is-danger",
                         }
    end

    school = params[:school]
    first_name = params[:first_name].titleize
    password = SessionsService.encrypt_password(params[:password])
    user = User.new({
                           :email => email,
                           :password => password,
                           :first_name => first_name,
                           :school => school,
                           :is_cas_authenticated => false
                       })

    if not user.save
      return redirect_to login_url,
                         :flash => {
                             :notice => "Cannot create account",
                             :notice_subtitle => "Please fill out all fields to create your account.",
                             :notice_class => "is-danger",
                         }
    end

    session[:current_user_id] = user.id
    redirect_to root_url, :notice => "Account created. Welcome, #{current_user.first_name}."
  end

  def create_via_credentials
    email = params[:email]
    password = params[:password]
    user = SessionsService.authenticate_account(email, password)

    if(!user)
      return redirect_to login_url,
                         :flash => {
                             :notice => "Cannot sign in",
                             :notice_subtitle => "An account with that email address and password combination was not found.",
                             :notice_class => "is-danger"
                         }
    end

    session[:current_user_id] = user.id
    redirect_to root_url, :notice => "Login successful. Welcome, #{current_user.first_name}."
  end

  def create_via_cas
    # We have different post-authentication endpoints depending on staging / production environments
    root_domain = if request.subdomains.first == 'staging'
                  then 'staging.aspc.pomona.edu'
                  else 'aspc.pomonastudents.org'
                  end

    next_page = '/'
    service_url = 'https://' + root_domain + Rails.application.routes.url_helpers.login_cas_path + '?next=' + CGI::escape(next_page)
    ticket = params[:ticket]

    # if request doesn't have CAS Ticket, direct them there
    return redirect_to _login_url(service_url) unless ticket

    # otherwise attempt login
    begin
      user_info = SessionsService.authenticate_ticket(ticket, service_url)
    rescue
      return redirect_to login_url,
                         :flash => {
                             :notice => "Authentication Failed",
                             :notice_subtitle => "Your school might not yet allow you to authenticate against CAS for this website",
                             :notice_class => "is-danger"
                         }
    end

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
    redirect_to root_url, :notice => "Login successful. Welcome, #{current_user.first_name}."
  end

  def _login_url(service_url)
    query_params = {
      :service => service_url
    }

    cas_server_url = Rails.application.credentials[:cas_settings][:server_url]
    [cas_server_url, 'login'].join('/') + '?' + query_params.to_query.to_s
  end
end
