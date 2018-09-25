class StaticController < ApplicationController
  def index
    @announcements = Announcement.all
    @events = Event.where("start >= ?", DateTime.now - 1).where(:status => :approved).order(:start).take(3)
  end
end
