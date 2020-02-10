# app/services/engage_events_service.rb

class EngageEventsService
    def initialize()
    end

    def get_events()
        headers = {
            "Accept" => "application/json",
            "X-Engage-Api-Key" => Rails.application.credentials.engage_api[:production]
        }

        start_time = Time.now.to_i * 1000	# in milliseconds
        end_time = start_time + 30*24*3600*1000	# +30 days

        query = {
            "startDate" => start_time,
            "endDate" => end_time
        }

        response = HTTParty.get(Rails.application.credentials.engage_api[:url], :headers => headers, :query => query)

        engage_events = response["items"]		# @events is a list of hashes, each of which is an event

        # save to db on the fly, then let events_controller pull from db
        engage_events.each do |event|
            # if event is marked for organisation only, then skip
            if event["typeName"] == "Organization Only"
                next
            end

            # if event already exists in database (checking with eventUrl), then skip
            if Event.exists?(details_url: event["eventUrl"])
                next
            end
                
            # if an event starts 12pm PST, the controller expects an input of 12pm UTC (rather than 8pm UTC)
            # need to manually offset time
            offset = Time.now.in_time_zone("America/Los_Angeles").utc_offset
            start_time = Time.at(event["startDateTime"].to_i / 1000) + offset
            end_time = Time.at(event["endDateTime"].to_i / 1000) + offset

            # remove HTML tags from description
            description = ActionView::Base.full_sanitizer.sanitize(event["description"])

            @event = Event.new(
                :name => event["eventName"],
                :location => event["locationName"].presence || "N/A",	# return "N/A" if locationName is blank
                :description => description,
                :host => event["organizationName"],
                :details_url => event["eventUrl"],
                :start => start_time,
                :end => end_time
            )

            @event.approve!

            res = @event.save!
        end
    end
end