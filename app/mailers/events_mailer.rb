class EventsMailer < ApplicationMailer

  def event_notification_email(event)
    @event = event
    @recipient = Rails.application.credentials[:email][:product_manager][:username]
    mail(to: @recipient, subject: @event.name)
  end

end
