module ApplicationHelper
  def google_calendar_add_url (event)
    date_time = event.start.strftime('%Y%m%dT%H%M%S') + '/' + event.end.strftime('%Y%m%dT%H%M%S')
    return "https://calendar.google.com/calendar/r/eventedit?text=#{CGI.escape event.name}&dates=#{date_time}&details=#{CGI.escape event.description}&location=#{CGI.escape event.location}"
  end
  
  def avatar_photo (person)
    if person.image.attached?
      image_tag person.image
    else
      image_tag "static/placeholder.jpg"
    end
  end
end
