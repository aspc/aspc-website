require 'cgi'

class SessionsController < ApplicationController
  PHP_AUTH_URL = "https://pomonastudents.org/php-auth/"
  layout "blank"

  def new
    @redirected_from_vote_app = params[:next].present? && params[:next] == "vote"
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to PHP_AUTH_URL + "logout.php"
  end

  def not_authorized
  end

  def create_new_account
    email = params[:email]
    user = User.find_by(:email => email)

    if user
      respond_to do |format|
        format.js { render partial: "components/toast", locals: {message: "Cannot create account. Account with provided email already exists.", type: "is-danger"} }
      end
    else
      school = params[:school]
      first_name = params[:first_name].titleize
      password = SessionsService.encrypt_password(params[:password])
      user = User.new({
                          :email => email,
                          :password => password,
                          :first_name => first_name,
                          :school => school,
                          :role => :user,
                          :is_cas_authenticated => false
                      })

      if user.save
        session[:current_user_id] = user.id
        respond_to do |format|
          flash[:notice] = "Account created. Welcome, #{current_user.first_name}."
          flash[:notice_class] = "is-success"
          format.js { render js: "window.location='#{root_url.to_s}'" }
        end
      else
        respond_to do |format|
          format.js { render partial: "components/toast", locals: {message: "Cannot create account. Please fill out all fields to create your account.", type: "is-danger"} }
        end
      end
    end
  end

  def create_via_credentials
    email = params[:email]
    password = params[:password]
    user = SessionsService.authenticate_account(email, password)

    if user
      session[:current_user_id] = user.id
      respond_to do |format|
        # flash[:notice] = "Login successful. Welcome, #{current_user.first_name}."
        # flash[:notice_class] = "is-success"
        format.js { render js: "window.location='#{root_url.to_s}'" }
      end
    else
      respond_to do |format|
        format.js { render partial: "components/toast", locals: {message: "We could not find a user with given e-mail and password. Please try again.", type: "is-danger"} }
      end
    end
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
    Rails.logger.debug 'SERVICE_URL: ' + service_url
    Rails.logger.debug '_LOGIN_URL: ' + _login_url(service_url)
    return redirect_to _login_url(service_url) unless ticket

    # otherwise attempt login
    begin
      user_info = SessionsService.authenticate_ticket(ticket, service_url)
    rescue => exception
      Rails.logger.debug exception.inspect
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
        :is_cas_authenticated => true,
        :role => :user
      })
    end

    # then create the login session for the user
    session[:current_user_id] = user.id

    # TODO: complete PHP session login/authentication and redirect user
    return redirect_to PHP_AUTH_URL + "login.php"
  end

  def _login_url(service_url)
    query_params = {
      :service => service_url
    }

    cas_server_url = Rails.application.credentials[:cas_settings][:server_url]
    [cas_server_url, 'login'].join('/') + '?' + query_params.to_query.to_s
  end
end
