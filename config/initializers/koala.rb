Koala.configure do |config|
  config.oauth_callback_url= "https://pomonastudents.org/"
  config.app_id = ENV['FACEBOOK_API_APP_ID']
  config.app_secret = ENV['FACEBOOK_API_APP_SECRET']
end