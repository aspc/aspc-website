require "koala"
require "watir"
require "cgi"

namespace :event_import do
  desc "Import events from Facebook"
  task :facebook => :environment do

    # NOTE: Facebook API application has to be authorized manually once by to going to the URL that
    # url_for_oauth_code method generates while logged in onto Facebook.

    # Create new Koala OAuth instance and get login URL
    oauth = Koala::Facebook::OAuth.new(304242016900984, "e1a63d3689a29d89a2be03b6598de8bc", "https://pomonastudents.org/")
    url_for_oauth_code = oauth.url_for_oauth_code(:permissions => "manage_pages")

    # Log in to Facebook
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto("https://www.facebook.com")
    browser.text_field(:id => "email").set(ENV["FACEBOOK_DEV_EMAIL"])
    browser.text_field(:id => "pass").set(ENV["FACEBOOK_DEV_PASSWORD"])
    browser.button(:type => "submit").click

    # Check whether login was sucessful (assuming that Facebook ASPC dev account has 'ASPC' in its name)
    if browser.text.include? "ASPC"
      puts "Login successful"

      # Open Facebook OAuth URL, which should then redirect browser to pomonastudents.org with "code" as a query parameter
      browser.goto(url_for_oauth_code)
      url = browser.url
      uri = URI.parse(url)
      params = CGI.parse(uri.query)
      code = params["code"].first

      access_token = oauth.get_access_token(code)
      user_graph = Koala::Facebook::API.new access_token
      pages = user_graph.get_connections("me", "accounts")

      # Destroy all existing imported events to avoid duplicates
      Event.where(:source => :facebook).destroy_all

      pages.each do |page|
        page_token = page["access_token"]
        page_graph = Koala::Facebook::API.new page_token
        events = page_graph.get_connection("me", "events", {:time_filter => :upcoming})

        events.each do |event|
          # Convert event place information into a has and convert that hash to a human-readable string
          place = {}
          place["name"] = event["place"]["name"]
          place["street"] = event["place"]["location"]["street"]
          place["city"] = event["place"]["location"]["city"]
          place["state"] = event["place"]["location"]["state"]
          place["zip"] = event["place"]["location"]["zip"]
          place.delete_if {|_, v| v.empty?}
          location = place.collect {|_, v| "#{v}"}.join(", ")

          # Parse start and end times
          start_time = DateTime.parse(event["start_time"])
          end_time = DateTime.parse(event["end_time"])

          # Create a new event
          Event.create!(:name => event["name"], :description => event["description"], :start => start_time, :end => end_time, :location => location, :source => :facebook, :status => :approved, :submitted_by_user_fk => 1)
        end
      end
    else
      puts "Login failed"
    end
  end
end
