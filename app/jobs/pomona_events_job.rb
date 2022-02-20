
class PomonaEventsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Check obsidianDocs for PomonaTrumbaEvent interface 
    jsonData = get_event_json
    puts jsonData[0]
    
  end

  def get_event_json() 
    request = HTTParty.get("https://www.trumba.com/calendars/pomona-college-json.json")
    return JSON.parse(request.body)
  end 

end
