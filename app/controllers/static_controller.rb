class StaticController < ApplicationController
  def index
    @announcements = Announcement.all
    time = Time.parse(Time.now.in_time_zone("Pacific Time (US & Canada)").strftime('%Y-%m-%d %H:%M:%S')).to_s(:db)
    @events = Event.where("start >= ?", time).where(:status => :approved).order(:start).take(3)
  end
  def aspc_senators
    @senators = Person.senator
  end
  def aspc_staff
    @staff = Person.staff
    @bot = Person.bot
  end
end
