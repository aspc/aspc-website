require 'httparty'
require 'digest/sha1'

class SessionsService
  # Corresponds to https://github.com/aspc/mainsite/blob/master/aspc/auth2/backends.py
  # Verifies CAS 2.0+ XML-based authentication ticket
  # Returns complete user data dictionary on success and raises an exception on failure
  #
  # Example response:
  #
  # <cas:serviceResponse xmlns:cas='http://www.yale.edu/tp/cas'>
  #	<cas:authenticationSuccess>
  #	<!-- Begin Ldap Attributes -->
  #		<cas:attributes>
  #			<cas:lastName>Dahl</cas:lastName>
  #			<cas:EmailAddress>mdd32013@MyMail.pomona.edu</cas:EmailAddress>
  #			<cas:fullName>Matthew Daniel Dahl</cas:fullName>
  #			<cas:firstName>Matthew</cas:firstName>
  #		</cas:attributes>
  #	<!-- End Ldap Attributes -->
  #	</cas:authenticationSuccess>
  # </cas:serviceResponse>
  def self.authenticate_ticket(ticket, service_url)
    query_params = {
      :ticket => ticket,
      :service => service_url
    }

    cas_server_url = Rails.application.credentials[:cas_settings][:server_url]
    validate_url = [cas_server_url, 'serviceValidate'].join('/') + '?' + query_params.to_query.to_s

    Rails.logger.info "Validating ticket against #{validate_url}"
    # validation_response = HTTParty.get(validate_url, :format => :xml).parsed_response
    validation_response_raw = HTTParty.get(validate_url, :format => :xml)
    Rails.logger.debug validation_response_raw
    validation_response = validation_response_raw.parsed_response
    Rails.logger.debug validation_response

    validation_response_body = validation_response['serviceResponse']['authenticationSuccess']['attributes']

    user_info = {
		  :email => '',
		  :full_name => '',
		  :first_name => '',
		  :last_name => ''
    }

    user_info[:email] = validation_response_body['EmailAddress']
    user_info[:full_name] = validation_response_body['fullName']
    user_info[:first_name] = validation_response_body['firstName']
    user_info[:last_name] = validation_response_body['lastName']

    return user_info
  end

  def self.encrypt_password(password)
    Digest::SHA1.hexdigest password + Rails.application.credentials[:account_authentication][:salt]
  end

  def self.authenticate_account(email, password)
    encrypted_password = self.encrypt_password(password)
    user = User.find_by(:email => email, :password => encrypted_password)

    return user
  end
end
