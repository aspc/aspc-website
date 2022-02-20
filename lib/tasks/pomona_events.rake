



namespace :pomona_events do 
    task :import do
        # Event JSON
        request = HTTParty.get("https://www.trumba.com/calendars/pomona-college-json.json")
        json = JSON.parse(request.body)

        

    end


end 

