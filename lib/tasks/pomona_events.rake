namespace :pomona_events do 
    task :update => :environment do
        # Event JSON
        json_data = retrieve_event_json
        json_data.each { |event|
            if !entry_already_exists event
                create_event event 
            end 
        }
    end
end 

def create_event(json_data) 
    event_id = json_data["eventID"]
 
    if !has_title json_data 
        return 
    end 

    new_event = transform_json_to_event json_data
    event = Event.new do |e| 
        e.name = new_event["name"]
        e.start = new_event["start"]
        e.status = new_event["status"]
        e.end  = new_event["end"]
        e.location = new_event["location"]
        e.description = new_event["description"]
        e.host = new_event["host"] 
        e.details_url = new_event["details_url"]
        e.college_affiliation = new_event["college_affiliation"]
        e.submitted_by_user_fk = 0 
    end 
    event.save!
    PomonaEventMap.create(event_id:event_id,mapped_id:event.id)
end 

def entry_already_exists(data)
    event_id = data["eventID"]
    return PomonaEventMap.where(event_id:event_id).exists?(condition = :none)
end 

def transform_json_to_event(data) 
    return {
        "status" => 1,
        "name" => (extract_field data["title"]),
        "start" => (extract_field data["startDateTime"]),
        "end" => (extract_field data["endDateTime"]),
        "college_affiliation" => 1,
        "location" => (extract_field data["location"]),
        "description" => (extract_field data["description"]),
        "host" => "Pomona", #@todo Figure out if this is correct
        "details_url" =>(extract_field data["webLink"]),
    }

end

def has_title(data) 
    if (data["title"].empty?)
        return false 
    end 

    return true 
end 

def extract_field(field)
    if field.nil? or field.empty?
        return "N/A" 
    end 
    return field 
end 

def retrieve_event_json() 
    # Event JSON
    request = HTTParty.get("https://www.trumba.com/calendars/pomona-college-json.json")
    return JSON.parse(request.body)
end 