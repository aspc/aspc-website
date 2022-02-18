class EventsMailer < ApplicationMailer

  def event_notification_email(event)
    @event = event
    @recipient = "sgab2018@mymail.pomona.edu"
    mail(to: @recipient, subject: @event.name)
  end

end
