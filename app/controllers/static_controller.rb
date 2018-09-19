class StaticController < ApplicationController
  def index
    @announcements = Announcement.all
  end
end
