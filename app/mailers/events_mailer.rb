class EventsMailer < ApplicationMailer

  def event_notification_email(event)
    @event = event
    @recipient = [Rails.application.credentials[:email][:product_manager][:username],
                  Rails.application.credentials[:email][:lead_developer][:username]]
    mail(to: @recipient, subject: 'New event submitted to pomonastudents.org')
  end

end
